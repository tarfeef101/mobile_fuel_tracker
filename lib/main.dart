import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqlcipher/drift_sqlcipher.dart';
import 'package:drift_sqlcipher/src/sqlcipher_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'models/fill_entry.dart';
import 'data/database.dart';
import 'services/settings_service.dart';
import 'data/dynamodb_service.dart';
import 'services/sync_service.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final settingsService = await SettingsService.create();
  final database = await DatabaseService.create();
  final dynamoDBService = DynamoDBService(settingsService);
  final syncService = SyncService(
    databaseService: database,
    dynamoDBService: dynamoDBService,
    settingsService: settingsService,
  );

  runApp(MyApp(
    settingsService: settingsService,
    database: database,
    dynamoDBService: dynamoDBService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final SyncService syncService;

  const MyApp({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamicColor, darkDynamicColor) {
        return MaterialApp(
          title: 'Fuel Tracker',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamicColor?.getColorScheme() ??
                ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.green,
                ),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDynamicColor?.getColorScheme() ??
                ColorScheme.dark(
                  primary: Colors.blue,
                  secondary: Colors.green,
                ),
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system,
          home: DashboardScreen(
            settingsService: settingsService,
            database: database,
            dynamoDBService: dynamoDBService,
            syncService: syncService,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}