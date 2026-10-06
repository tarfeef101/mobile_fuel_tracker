import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/tire_size_screen.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  final Function() onBack;
  final Function() onSettingsChanged;
  final SettingsService settingsService;

  const SettingsScreen({super.key, required this.onBack, required this.onSettingsChanged, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _SettingsItem(
              title: 'Fuel Type',
              subtitle: 'Select default fuel type',
            ),
            _SettingsItem(
              title: 'Distance Unit',
              subtitle: 'Select distance unit',
            ),
            _SettingsItem(
              title: 'Capacity Unit',
              subtitle: 'Select capacity unit',
            ),
            _SettingsItem(
              title: 'Currency',
              subtitle: 'Select default currency',
            ),
            SizedBox(height: 30),
            Text(
              'Tire Size Offset',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _TireSizeSettingsItem(
              title: 'Stock Tire Size',
              subtitle: 'Enter your vehicle\'s original tire size',
            ),
            _TireSizeSettingsItem(
              title: 'Running Tire Size',
              subtitle: 'Enter your current tire size',
            ),
            SizedBox(height: 30),
            Text(
              'Cloud Sync',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _SettingsItem(
              title: 'Enable Cloud Sync',
              subtitle: 'Sync data with AWS DynamoDB',
            ),
            _SettingsItem(
              title: 'AWS Configuration',
              subtitle: 'Configure AWS credentials',
            ),
            _SettingsItem(
              title: 'DynamoDB Table',
              subtitle: 'Select table name',
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}

class _TireSizeSettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TireSizeSettingsItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to tire size screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TireSizeScreen(
                settingsService: context.read<SettingsService>(),
                onBack: () {
                  Navigator.of(context).pop();
                },
                onSettingsChanged: () {
                  // Rebuild the screen to update settings
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}