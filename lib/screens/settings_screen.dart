import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../services/settings_service.dart';
import '../services/sync_service.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import 'vehicle_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final SyncService syncService;
  final ThemeModeNotifier themeModeNotifier;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
    required this.themeModeNotifier,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsService _settingsService;
  late final DatabaseService _database;

  final _accessKeyIdController = TextEditingController();
  final _secretAccessKeyController = TextEditingController();
  final _regionController = TextEditingController();
  final _tableNameController = TextEditingController();

  bool _cloudSyncEnabled = false;
  String _syncFrequency = 'manual';
  String _themeMode = 'system';
  bool _isTesting = false;
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _settingsService = widget.settingsService;
    _database = widget.database;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final accessKey = await _settingsService.getAwsAccessKeyId();
    final secretKey = await _settingsService.getAwsSecretAccessKey();
    if (!mounted) return;
    setState(() {
      _accessKeyIdController.text = accessKey ?? '';
      _secretAccessKeyController.text = secretKey ?? '';
      _regionController.text = _settingsService.getAwsRegion();
      _tableNameController.text = _settingsService.getDynamoDbTableName();
      _cloudSyncEnabled = _settingsService.getEnableCloudSync();
      _syncFrequency = _settingsService.getSyncFrequency();
      _themeMode = _settingsService.getThemeMode();
    });
  }

  @override
  void dispose() {
    _accessKeyIdController.dispose();
    _secretAccessKeyController.dispose();
    _regionController.dispose();
    _tableNameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildCurrencySelector(),
            const SizedBox(height: 15),

            _buildDistanceUnitSelector(),
            const SizedBox(height: 15),

            _buildCapacityUnitSelector(),
            const SizedBox(height: 15),

            _buildThemeSelector(),
            const SizedBox(height: 30),

            const Text(
              'Cloud Sync',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildCloudSyncToggle(),
            const SizedBox(height: 15),

            _buildSyncFrequencySelector(),
            const SizedBox(height: 15),

            _buildAwsConfigCard(),
            const SizedBox(height: 30),

            const Text(
              'Vehicle Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildVehicleManagement(),
            const SizedBox(height: 30),

            const Text(
              'Data Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildDataExport(),
            const SizedBox(height: 15),

            _buildDataImport(),
            const SizedBox(height: 15),

            _buildResetData(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return ListTile(
      title: const Text('Currency'),
      subtitle: Text(_settingsService.getCurrency()),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: _showCurrencySelector,
    );
  }

  Widget _buildDistanceUnitSelector() {
    return ListTile(
      title: const Text('Distance Unit'),
      subtitle: Text(_settingsService.getDistanceUnit()),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: _showDistanceUnitSelector,
    );
  }

  Widget _buildCapacityUnitSelector() {
    return ListTile(
      title: const Text('Capacity Unit'),
      subtitle: Text(_settingsService.getCapacityUnit()),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: _showCapacityUnitSelector,
    );
  }

  Widget _buildThemeSelector() {
    final labels = {'system': 'System', 'light': 'Light', 'dark': 'Dark'};
    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(labels[_themeMode] ?? 'System'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              // Bottom sheets render under the system nav bar; reserve for it.
              padding: EdgeInsets.only(
                left: 16.0,
                top: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Theme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...labels.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      leading: Radio<String>(
                        value: entry.key,
                        groupValue: _themeMode,
                        onChanged: (value) {
                          Navigator.of(context).pop();
                          if (value == null) return;
                          _applyThemeMode(value);
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _applyThemeMode(String mode) async {
    setState(() => _themeMode = mode);
    await _settingsService.setThemeMode(mode);
    widget.themeModeNotifier.set(
      mode == 'light' ? ThemeMode.light : mode == 'dark' ? ThemeMode.dark : ThemeMode.system,
    );
  }

  Widget _buildCloudSyncToggle() {
    return ListTile(
      title: const Text('Cloud Sync'),
      subtitle: const Text('Sync data with cloud storage'),
      trailing: Switch(
        value: _cloudSyncEnabled,
        onChanged: (value) async {
          setState(() => _cloudSyncEnabled = value);
          await _settingsService.setEnableCloudSync(value);
          await widget.syncService.scheduleBackgroundSync();
        },
      ),
    );
  }

  Widget _buildSyncFrequencySelector() {
    final labels = {
      'manual': 'Manual only',
      'on_close': 'On app close',
      'hourly': 'Every hour',
      'daily': 'Every day',
    };
    return ListTile(
      title: const Text('Sync Frequency'),
      subtitle: Text(labels[_syncFrequency] ?? 'Manual only'),
      trailing: const Icon(Icons.arrow_forward_ios),
      enabled: _cloudSyncEnabled,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                left: 16.0,
                top: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sync Frequency',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...labels.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      leading: Radio<String>(
                        value: entry.key,
                        groupValue: _syncFrequency,
                        onChanged: (value) {
                          Navigator.of(context).pop();
                          if (value == null) return;
                          _applySyncFrequency(value);
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _applySyncFrequency(String frequency) async {
    setState(() => _syncFrequency = frequency);
    await _settingsService.setSyncFrequency(frequency);
    await widget.syncService.scheduleBackgroundSync();
  }

  Widget _buildAwsConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AWS Configuration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accessKeyIdController,
              decoration: const InputDecoration(
                labelText: 'Access Key ID',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _secretAccessKeyController,
              decoration: const InputDecoration(
                labelText: 'Secret Access Key',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _regionController,
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tableNameController,
              decoration: const InputDecoration(
                labelText: 'DynamoDB Table Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isTesting ? null : _testConnection,
                  child: _isTesting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Test Connection'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isTesting ? null : _saveAwsSettings,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAwsSettings() async {
    final region = _regionController.text.trim();
    final table = _tableNameController.text.trim();
    await _settingsService.setAwsAccessKeyId(_accessKeyIdController.text.trim());
    await _settingsService.setAwsSecretAccessKey(_secretAccessKeyController.text.trim());
    await _settingsService.setAwsRegion(region.isEmpty ? 'us-east-1' : region);
    await _settingsService.setDynamoDbTableName(table.isEmpty ? 'FuelTrackerEntries' : table);
    _showSnackBar('AWS settings saved');
  }

  Future<void> _testConnection() async {
    setState(() => _isTesting = true);
    try {
      final result = await widget.syncService.testAwsConnection();
      if (result.success) {
        _showSnackBar('Connection successful');
      } else {
        _showConnectionErrorDialog(result);
      }
    } catch (e) {
      _showConnectionErrorDialog(
          DynamoDbTestResult(success: false, message: '$e'));
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  void _showConnectionErrorDialog(DynamoDbTestResult result) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection failed'),
        content: SingleChildScrollView(
          child: SelectableText(result.message,
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

  Widget _buildVehicleManagement() {
    return ListTile(
      title: const Text('Manage Vehicles'),
      subtitle: const Text('Add, edit, and delete vehicles'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleListScreen(
              database: _database,
              settingsService: _settingsService,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataExport() {
    return ListTile(
      title: const Text('Export Data'),
      subtitle: const Text('Share all entries and vehicles as JSON'),
      trailing: _isExporting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.share),
      enabled: !_isExporting,
      onTap: _exportData,
    );
  }

  Widget _buildDataImport() {
    return ListTile(
      title: const Text('Import Data'),
      subtitle: const Text('Import fuel data from JSON file'),
      trailing: _isImporting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.file_open_outlined),
      enabled: !_isImporting,
      onTap: _importData,
    );
  }

  Widget _buildResetData() {
    return ListTile(
      title: const Text('Reset Data'),
      subtitle: const Text('Delete all local data (cannot be undone)'),
      trailing: _isResetting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.delete_outline),
      enabled: !_isResetting,
      onTap: _showResetConfirmation,
    );
  }

  Future<void> _exportData() async {
    try {
      setState(() => _isExporting = true);
      final entries = await _database.getAllFillEntries();
      final vehicles = await _database.getAllVehicles();
      final exportData = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'vehicles': vehicles.map((v) => v.toJson()).toList(),
        'entries': entries.map((e) => e.toJson()).toList(),
      };
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, 'fuel_tracker_export.json'));
      await file.writeAsString(jsonEncode(exportData));
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, name: 'fuel_tracker_export.json')]),
      );
    } catch (e) {
      _showSnackBar('Export failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _importData() async {
    try {
      setState(() => _isImporting = true);
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (files.isEmpty) return;
      final filePath = files.single.path;
      if (filePath == null) return;

      final content = await File(filePath).readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      var vehicleCount = 0;
      final vehicles = data['vehicles'] as List<dynamic>? ?? [];
      for (final item in vehicles) {
        final vehicle = Vehicle.fromJson(item as Map<String, dynamic>);
        await _database.insertVehicle(vehicle);
        vehicleCount++;
      }

      var entryCount = 0;
      final entries = data['entries'] as List<dynamic>? ?? [];
      for (final item in entries) {
        final entry = FillEntry.fromJson(item as Map<String, dynamic>);
        await _database.insertFillEntry(entry);
        entryCount++;
      }

      _showSnackBar('Imported $entryCount entries and $vehicleCount vehicles');
    } catch (e) {
      _showSnackBar('Import failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _showCurrencySelector() {
    _showOptionSheet('Select Currency', const ['USD', 'EUR', 'GBP', 'CAD', 'AUD'],
        (value) => _settingsService.setCurrency(value));
  }

  void _showDistanceUnitSelector() {
    _showOptionSheet('Select Distance Unit', const ['km', 'miles'],
        (value) => _settingsService.setDistanceUnit(value));
  }

  void _showCapacityUnitSelector() {
    _showOptionSheet('Select Capacity Unit', const ['L', 'gal', 'mL'],
        (value) => _settingsService.setCapacityUnit(value));
  }

  void _showOptionSheet(String title, List<String> options, Future<void> Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(option);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Data'),
          content: const Text(
              'Are you sure you want to delete all local data? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmReset();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmReset() async {
    try {
      setState(() => _isResetting = true);
      await _database.deleteAllFillEntries();
      await _database.deleteAllVehicles();
      await _settingsService.clearAllSettings();
      await widget.syncService.scheduleBackgroundSync();
      _showSnackBar('All data deleted');
      await _loadSettings();
    } catch (e) {
      _showSnackBar('Reset failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isResetting = false);
      }
    }
  }
}
