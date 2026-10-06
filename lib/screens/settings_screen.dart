import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../data/database.dart';
import '../models/vehicle.dart';
import 'vehicle_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.database,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  late DatabaseService _database;

  @override
  void initState() {
    super.initState();
    _settingsService = widget.settingsService;
    _database = widget.database;
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildCurrencySelector(),
            const SizedBox(height: 15),

            _buildDistanceUnitSelector(),
            const SizedBox(height: 15),

            _buildCapacityUnitSelector(),
            const SizedBox(height: 15),

            _buildCloudSyncToggle(),
            const SizedBox(height: 30),

            const Text(
              'Vehicle Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildVehicleManagement(),
            const SizedBox(height: 30),

            const Text(
              'Data Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showCurrencySelector();
      },
    );
  }

  Widget _buildDistanceUnitSelector() {
    return ListTile(
      title: const Text('Distance Unit'),
      subtitle: Text(_settingsService.getDistanceUnit()),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showDistanceUnitSelector();
      },
    );
  }

  Widget _buildCapacityUnitSelector() {
    return ListTile(
      title: const Text('Capacity Unit'),
      subtitle: Text(_settingsService.getCapacityUnit()),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showCapacityUnitSelector();
      },
    );
  }

  Widget _buildCloudSyncToggle() {
    return ListTile(
      title: const Text('Cloud Sync'),
      subtitle: const Text('Sync data with cloud storage'),
      trailing: Switch(
        value: _settingsService.getEnableCloudSync(),
        onChanged: (value) {
          _settingsService.setEnableCloudSync(value);
        },
      ),
    );
  }

  Widget _buildVehicleManagement() {
    return ListTile(
      title: const Text('Manage Vehicles'),
      subtitle: const Text('Add, edit, and delete vehicles'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleListScreen(
              database: _database,
              settingsService: _settingsService,
              onVehicleSelected: (vehicle) {
                // Handle vehicle selection if needed
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataExport() {
    return ListTile(
      title: const Text('Export Data'),
      subtitle: const Text('Export your fuel data'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Implement data export functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data export feature not implemented')),
        );
      },
    );
  }

  Widget _buildDataImport() {
    return ListTile(
      title: const Text('Import Data'),
      subtitle: const Text('Import fuel data from file'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Implement data import functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data import feature not implemented')),
        );
      },
    );
  }

  Widget _buildResetData() {
    return ListTile(
      title: const Text('Reset Data'),
      subtitle: const Text('Delete all local data (cannot be undone)'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showResetConfirmation();
      },
    );
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...['USD', 'EUR', 'GBP', 'CAD', 'AUD'].map((currency) {
                return ListTile(
                  title: Text(currency),
                  onTap: () {
                    _settingsService.setCurrency(currency);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showDistanceUnitSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Distance Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...['km', 'miles'].map((unit) {
                return ListTile(
                  title: Text(unit),
                  onTap: () {
                    _settingsService.setDistanceUnit(unit);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showCapacityUnitSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Capacity Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...['L', 'gal', 'mL'].map((unit) {
                return ListTile(
                  title: Text(unit),
                  onTap: () {
                    _settingsService.setCapacityUnit(unit);
                    Navigator.of(context).pop();
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
          content: const Text('Are you sure you want to delete all local data? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement data reset functionality
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data reset functionality not implemented')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}