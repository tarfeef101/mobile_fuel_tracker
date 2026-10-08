import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

import 'data/database.dart';
import 'data/dynamodb_service.dart';
import 'screens/dashboard_screen.dart';
import 'services/settings_service.dart';
import 'services/sync_service.dart';

// dynamic_color 2.x builds schemes with the standalone material_ui package,
// so translate the result back to the SDK's ColorScheme.
ColorScheme _toSdkColorScheme(material_ui.ColorScheme c) {
  return ColorScheme(
    brightness: c.brightness,
    primary: c.primary,
    onPrimary: c.onPrimary,
    primaryContainer: c.primaryContainer,
    onPrimaryContainer: c.onPrimaryContainer,
    primaryFixed: c.primaryFixed,
    primaryFixedDim: c.primaryFixedDim,
    onPrimaryFixed: c.onPrimaryFixed,
    onPrimaryFixedVariant: c.onPrimaryFixedVariant,
    secondary: c.secondary,
    onSecondary: c.onSecondary,
    secondaryContainer: c.secondaryContainer,
    onSecondaryContainer: c.onSecondaryContainer,
    secondaryFixed: c.secondaryFixed,
    secondaryFixedDim: c.secondaryFixedDim,
    onSecondaryFixed: c.onSecondaryFixed,
    onSecondaryFixedVariant: c.onSecondaryFixedVariant,
    tertiary: c.tertiary,
    onTertiary: c.onTertiary,
    tertiaryContainer: c.tertiaryContainer,
    onTertiaryContainer: c.onTertiaryContainer,
    tertiaryFixed: c.tertiaryFixed,
    tertiaryFixedDim: c.tertiaryFixedDim,
    onTertiaryFixed: c.onTertiaryFixed,
    onTertiaryFixedVariant: c.onTertiaryFixedVariant,
    error: c.error,
    onError: c.onError,
    errorContainer: c.errorContainer,
    onErrorContainer: c.onErrorContainer,
    surface: c.surface,
    onSurface: c.onSurface,
    surfaceDim: c.surfaceDim,
    surfaceBright: c.surfaceBright,
    surfaceContainerLowest: c.surfaceContainerLowest,
    surfaceContainerLow: c.surfaceContainerLow,
    surfaceContainer: c.surfaceContainer,
    surfaceContainerHigh: c.surfaceContainerHigh,
    surfaceContainerHighest: c.surfaceContainerHighest,
    surfaceVariant: c.surfaceVariant,
    onSurfaceVariant: c.onSurfaceVariant,
    outline: c.outline,
    outlineVariant: c.outlineVariant,
    shadow: c.shadow,
    scrim: c.scrim,
    inverseSurface: c.inverseSurface,
    onInverseSurface: c.onInverseSurface,
    inversePrimary: c.inversePrimary,
    surfaceTint: c.surfaceTint,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Fuel Tracker',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: lightDynamic != null
                ? _toSdkColorScheme(lightDynamic)
                : const ColorScheme.light(
                    primary: Colors.blue,
                    secondary: Colors.green,
                  ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: darkDynamic != null
                ? _toSdkColorScheme(darkDynamic)
                : const ColorScheme.dark(
                    primary: Colors.blue,
                    secondary: Colors.green,
                  ),
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
