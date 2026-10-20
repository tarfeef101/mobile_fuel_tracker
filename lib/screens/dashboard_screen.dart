import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/fill_entry.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/settings_service.dart';
import '../services/sync_service.dart';
import '../utils/currency.dart';
import '../utils/economy.dart';
import '../utils/tire.dart';
import '../widgets/entry_card_with_vehicle.dart';
import '../widgets/trend_line_chart.dart';
import 'add_entry_screen.dart';
import 'chart_detail_screen.dart';
import 'settings_screen.dart';

/// Data for a dashboard trend chart, shared between the inline card and the
/// fullscreen view.
typedef TrendChartSpec = ({
  String title,
  List<FlSpot> points,
  double? average,
  String avgLabel,
  String Function(double) yFormat,
  String Function(double) tooltipFormat,
});

class DashboardScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final SyncService syncService;
  final ThemeModeNotifier themeModeNotifier;

  const DashboardScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
    required this.themeModeNotifier,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<FillEntry> _fillEntries = [];
  Map<String, String> _vehicleNames = {};
  Map<String, double> _tireOffsets = {};
  Map<String, FillEconomy> _fillEconomies = {};
  String _period = '30';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSyncing = false;
  int _unsyncedCount = 0;
  DateTime? _lastSync;

  @override
  void initState() {
    super.initState();
    _loadFillEntries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFillEntries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _period = widget.settingsService.getHistoryPeriod();
      final entries = await widget.database.getAllFillEntries();
      final vehicles = await widget.database.getAllVehicles();
      final unsynced = widget.settingsService.getEnableCloudSync()
          ? await widget.database.getUnsyncedEntries()
          : <FillEntry>[];
      if (!mounted) return;
      final tireOffsets = {
        for (final v in vehicles) v.id: tireSizeOffset(v.tireSizeStock, v.tireSizeRunning) ?? 0,
      };
      // From the full history, so the "previous fill" for an entry at the
      // edge of a period filter is still found.
      final economies = fillEconomies(entries, tireOffsetByVehicle: tireOffsets);
      setState(() {
        _fillEntries = entries;
        _vehicleNames = {for (final v in vehicles) v.id: v.name};
        _tireOffsets = tireOffsets;
        _fillEconomies = economies;
        _unsyncedCount = unsynced.length;
        _lastSync = widget.settingsService.getLastSync();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load entries: $e';
      });
    }
  }

  Future<void> _syncEntries() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      if (widget.settingsService.getEnableCloudSync()) {
        final result = await widget.syncService.syncAllUnsyncedEntries();
        if (result.failed) {
          _showSyncErrorDialog(result.error!);
        } else if (result.hadWork) {
          final parts = <String>[];
          if (result.entries > 0) {
            parts.add('${result.entries} '
                '${result.entries == 1 ? 'entry' : 'entries'}');
          }
          if (result.deletions > 0) {
            parts.add('${result.deletions} '
                '${result.deletions == 1 ? 'deletion' : 'deletions'}');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Synced ${parts.join(' and ')} to cloud')),
          );
        }
        await _loadFillEntries();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  /// Sync errors can be long and diagnostic; a dialog is easier to read
  /// than a snackbar.
  void _showSyncErrorDialog(String message) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync failed'),
        content: SingleChildScrollView(
          child: SelectableText(message,
              style: const TextStyle(fontFamily: 'monospace')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<FillEntry> get _periodEntries {
    if (_period == 'all') return _fillEntries;
    final days = int.tryParse(_period);
    if (days == null) return _fillEntries;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _fillEntries.where((entry) => entry.timestamp.isAfter(cutoff)).toList();
  }

  List<FillEntry> get _visibleEntries {
    final query = _searchQuery.trim().toLowerCase();
    final base = _periodEntries;
    if (query.isEmpty) return base;
    return base.where((entry) {
      final vehicleName = _vehicleNames[entry.vehicleId] ?? '';
      return (entry.notes?.toLowerCase().contains(query) ?? false) ||
          fuelTypeLabel(entry.fuelType).toLowerCase().contains(query) ||
          entry.fuelType.toLowerCase().contains(query) ||
          vehicleName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Economy Tracker'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isSyncing
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : const Icon(Icons.sync),
            onPressed: _isSyncing ? null : _syncEntries,
            tooltip: _isSyncing ? 'Syncing...' : 'Sync Now',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    settingsService: widget.settingsService,
                    database: widget.database,
                    dynamoDBService: widget.dynamoDBService,
                    syncService: widget.syncService,
                    themeModeNotifier: widget.themeModeNotifier,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEntryScreen(
                settingsService: widget.settingsService,
                database: widget.database,
                dynamoDBService: widget.dynamoDBService,
                syncService: widget.syncService,
                onEntryAdded: _loadFillEntries,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFillEntries,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_fillEntries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_gas_station_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No entries yet',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first fuel entry to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final periodEntries = _periodEntries;
    final visible = _visibleEntries;

    // One scroll for the whole body: a pinned header plus Expanded(ListView)
    // collapses when the fixed header is taller than a landscape screen.
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(
        children: [
          _buildMetricsGrid(periodEntries),
          _buildSyncStatus(),
          _buildPeriodSelector(),
          _buildSearchField(),
          if (periodEntries.length >= 2) _buildCharts(periodEntries),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No entries match your search')),
            )
          else
            ...visible.map((entry) {
              return EntryCardWithVehicle(
                entry: entry,
                economy: _fillEconomies[entry.id],
                onDelete: _deleteEntry,
                onEdit: _editEntry,
                database: widget.database,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(List<FillEntry> entries) {
    final settings = widget.settingsService;
    final metrics = computeEconomy(entries, tireOffsetByVehicle: _tireOffsets);
    final miles = settings.getDistanceUnit() == 'miles';
    final currency = settings.getCurrency();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        children: [
          Row(
            children: [
              _metricCard(
                'Fuel economy',
                metrics.consumptionPer100Km != null
                    ? formatConsumption(metrics.consumptionPer100Km!, miles: miles)
                    : '—',
              ),
              const SizedBox(width: 8),
              _metricCard(
                'Avg cost / fill',
                '$currency ${metrics.averageCostPerFill.toStringAsFixed(2)}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _metricCard(
                'Total cost',
                '$currency ${metrics.totalCost.toStringAsFixed(2)}',
              ),
              const SizedBox(width: 8),
              _metricCard(
                'Distance',
                formatDistance(metrics.totalDistanceKm, miles: miles),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatus() {
    final hasUnsynced = _unsyncedCount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(
            hasUnsynced ? Icons.cloud_upload_outlined : Icons.cloud_done,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasUnsynced
                  ? '$_unsyncedCount unsynced entries'
                  : _lastSync != null
                      ? 'Synced ${DateFormat('MMM d, HH:mm').format(_lastSync!)}'
                      : 'Not synced yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    const periods = {'7': '7 days', '30': '30 days', '90': '90 days', 'all': 'All'};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: periods.entries.map((entry) {
          return ChoiceChip(
            label: Text(entry.value),
            selected: _period == entry.key,
            onSelected: (selected) {
              if (!selected) return;
              _period = entry.key;
              widget.settingsService.setHistoryPeriod(entry.key);
              setState(() {});
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _searchQuery = value;
          setState(() {});
        },
        decoration: const InputDecoration(
          hintText: 'Search by notes, vehicle, or fuel type',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  /// Per-fill series for the charts, using the last 30 fills of the period.
  /// Economy comes from the full-history segment map (tire-corrected) and is
  /// shown in the user's unit; cost is dollars per unit of capacity.
  ({List<FlSpot> economy, List<FlSpot> cost}) _chartSeries(List<FillEntry> entries) {
    final miles = widget.settingsService.getDistanceUnit() == 'miles';
    final chronological = [...entries]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final recent = chronological.length > 30
        ? chronological.sublist(chronological.length - 30)
        : chronological;

    final economy = <FlSpot>[];
    for (final entry in recent) {
      final perFill = _fillEconomies[entry.id];
      if (perFill == null) continue;
      economy.add(FlSpot(
        entry.timestamp.millisecondsSinceEpoch.toDouble(),
        miles ? 235.215 / perFill.consumptionPer100Km : perFill.consumptionPer100Km,
      ));
    }

    final cost = <FlSpot>[];
    for (final entry in recent) {
      final amount = entryFuelAmount(entry);
      if (amount == null || amount <= 0) continue;
      cost.add(FlSpot(
        entry.timestamp.millisecondsSinceEpoch.toDouble(),
        entry.totalCost / amount,
      ));
    }

    return (economy: economy, cost: cost);
  }

  /// Chart title row with a button to expand the chart fullscreen.
  Widget _chartHeader(String title, VoidCallback onExpand) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.open_in_full, size: 20),
            tooltip: 'Expand chart',
            onPressed: onExpand,
          ),
        ],
      ),
    );
  }

  Widget _buildCharts(List<FillEntry> entries) {
    final settings = widget.settingsService;
    final miles = settings.getDistanceUnit() == 'miles';
    final currency = settings.getCurrency();
    final fraction = currencyFractionDigits(currency);
    final unit = settings.getCapacityUnit();
    final series = _chartSeries(entries);
    if (series.economy.length < 2 && series.cost.length < 2) {
      return const SizedBox.shrink();
    }

    // Weighted averages over the whole period instead of the plotted points.
    final metrics = computeEconomy(entries, tireOffsetByVehicle: _tireOffsets);
    final economyAvg = metrics.consumptionPer100Km == null
        ? null
        : miles
              ? 235.215 / metrics.consumptionPer100Km!
              : metrics.consumptionPer100Km!;
    final costAvg = averageCostPerUnit(entries);
    final economyUnit = miles ? 'mpg' : 'L/100km';
    final TrendChartSpec economyChart = (
      title: 'Fuel economy over time',
      points: series.economy,
      average: economyAvg,
      avgLabel: 'avg ${_avgLine(economyAvg, series.economy).toStringAsFixed(1)} $economyUnit',
      yFormat: (value) => value.toStringAsFixed(1),
      tooltipFormat: (value) => '${value.toStringAsFixed(2)} $economyUnit',
    );
    final TrendChartSpec costChart = (
      title: 'Fuel cost over time',
      points: series.cost,
      average: costAvg,
      avgLabel: 'avg $currency${_avgLine(costAvg, series.cost).toStringAsFixed(fraction)}/$unit',
      yFormat: (value) => value.toStringAsFixed(fraction),
      tooltipFormat: (value) => '$currency${value.toStringAsFixed(fraction)}/$unit',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (series.economy.length >= 2) ...[
                _chartHeader(economyChart.title, () => _openTrendChart(economyChart)),
                TrendLineChart(
                  points: economyChart.points,
                  average: economyChart.average,
                  avgLabel: economyChart.avgLabel,
                  yFormat: economyChart.yFormat,
                  tooltipFormat: economyChart.tooltipFormat,
                  height: 160,
                ),
              ],
              if (series.economy.length >= 2 && series.cost.length >= 2)
                const SizedBox(height: 24),
              if (series.cost.length >= 2) ...[
                _chartHeader(costChart.title, () => _openTrendChart(costChart)),
                TrendLineChart(
                  points: costChart.points,
                  average: costChart.average,
                  avgLabel: costChart.avgLabel,
                  yFormat: costChart.yFormat,
                  tooltipFormat: costChart.tooltipFormat,
                  height: 160,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openTrendChart(TrendChartSpec chart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChartDetailScreen(
          title: chart.title,
          points: chart.points,
          average: chart.average,
          avgLabel: chart.avgLabel,
          yFormat: chart.yFormat,
          tooltipFormat: chart.tooltipFormat,
        ),
      ),
    );
  }

  double _avgY(List<FlSpot> points) =>
      points.map((p) => p.y).reduce((a, b) => a + b) / points.length;

  double _avgLine(double? weighted, List<FlSpot> points) =>
      weighted ?? _avgY(points);

  void _editEntry(FillEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEntryScreen(
          settingsService: widget.settingsService,
          database: widget.database,
          dynamoDBService: widget.dynamoDBService,
          syncService: widget.syncService,
          entryToEdit: entry,
          onEntryAdded: _loadFillEntries,
        ),
      ),
    );
  }

  void _deleteEntry(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text(
              'Are you sure you want to delete this entry? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDelete(id);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String id) {
    widget.database.deleteFillEntry(id).then((_) {
      _loadFillEntries();
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting entry: $error')),
        );
      }
    });
  }
}
