import 'package:flutter/material.dart';

import '../models/fill_entry.dart';
import '../services/settings_service.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/sync_service.dart';
import '../widgets/entry_card_with_vehicle.dart';
import 'add_entry_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final SyncService syncService;

  const DashboardScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<FillEntry> _fillEntries = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadFillEntries();
  }

  Future<void> _loadFillEntries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final entries = await widget.database.getAllFillEntries();
      setState(() {
        _fillEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
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
      // Check if cloud sync is enabled
      if (widget.settingsService.getEnableCloudSync()) {
        final syncedCount = await widget.syncService.syncAllUnsyncedEntries();
        if (syncedCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Synced $syncedCount entries to cloud')),
          );
          // Reload entries to show updated status
          await _loadFillEntries();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync failed: $e')),
      );
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Tracker'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isSyncing ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : const Icon(Icons.sync),
            onPressed: _isSyncing ? null : _syncEntries,
            tooltip: _isSyncing ? 'Syncing...' : 'Sync Now',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    settingsService: widget.settingsService,
                    database: widget.database,
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
          // Navigate to add entry screen
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

    return ListView.builder(
      itemCount: _fillEntries.length,
      itemBuilder: (context, index) {
        final entry = _fillEntries[index];
        return EntryCardWithVehicle(
          entry: entry,
          onDelete: _deleteEntry,
          database: widget.database,
        );
      },
    );
  }

  void _deleteEntry(String id) {
    widget.database.deleteFillEntry(id).then((_) {
      _loadFillEntries(); // Reload the entries
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $error')),
      );
    });
  }
}
