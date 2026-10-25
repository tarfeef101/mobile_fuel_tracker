import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:workmanager/workmanager.dart';

import 'data/database.dart';
import 'data/dynamodb_service.dart';
import 'screens/dashboard_screen.dart';
import 'services/exchange_rate_service.dart';
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

/// Holds the active theme mode so screens can update it live.
class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _mode;

  ThemeModeNotifier(this._mode);

  ThemeMode get value => _mode;

  void set(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

@pragma('vm:entry-point')
void _workManagerCallback() {
  Workmanager().executeTask((taskId, inputData) async {
    await runBackgroundSync();
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(_workManagerCallback);

  final settingsService = await SettingsService.create();
  final database = await DatabaseService.create();
  final dynamoDBService = DynamoDBService(settingsService);
  final exchangeRateService = await ExchangeRateService.create();
  final syncService = SyncService(
    databaseService: database,
    dynamoDBService: dynamoDBService,
    settingsService: settingsService,
  );
  await syncService.scheduleBackgroundSync();

  // Pin the exchange rate on entries saved before rate pinning existed.
  // Best effort: a failure here must not block start-up.
  try {
    await database.pinExchangeRates(
      defaultCurrency: settingsService.getCurrency(),
      rateFor: exchangeRateService.getRates,
    );
  } catch (_) {}

  final themeMode = switch (settingsService.getThemeMode()) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
  final themeModeNotifier = ThemeModeNotifier(themeMode);

  runApp(MyApp(
    settingsService: settingsService,
    database: database,
    dynamoDBService: dynamoDBService,
    exchangeRateService: exchangeRateService,
    syncService: syncService,
    themeModeNotifier: themeModeNotifier,
  ));
}

class MyApp extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final ExchangeRateService exchangeRateService;
  final SyncService syncService;
  final ThemeModeNotifier themeModeNotifier;

  const MyApp({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.exchangeRateService,
    required this.syncService,
    required this.themeModeNotifier,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeMode = widget.themeModeNotifier.value;
    widget.themeModeNotifier.addListener(_themeModeChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.themeModeNotifier.removeListener(_themeModeChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Best-effort "on app close" sync: fire before Android may kill the
    // process; anything left over stays flagged as unsynced.
    if (state == AppLifecycleState.hidden &&
        widget.settingsService.getSyncFrequency() == 'on_close' &&
        widget.settingsService.getEnableCloudSync()) {
      widget.syncService.syncAllUnsyncedEntries();
    }
  }

  void _themeModeChanged() {
    setState(() {
      _themeMode = widget.themeModeNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Fuel Economy Tracker',
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
          themeMode: _themeMode,
          home: DashboardScreen(
            settingsService: widget.settingsService,
            database: widget.database,
            dynamoDBService: widget.dynamoDBService,
            exchangeRateService: widget.exchangeRateService,
            syncService: widget.syncService,
            themeModeNotifier: widget.themeModeNotifier,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
