import 'package:clay_containers/theme/clay_text_theme.dart';
import 'package:clay_containers/theme/clay_theme.dart';
import 'package:clay_containers/theme/clay_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/pages/home.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/theme/app_theme.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return ClayTheme(
      themeData: const ClayThemeData(
        height: 10,
        width: 20,
        borderRadius: 360,
        textTheme: ClayTextTheme(style: TextStyle()),
        depth: 12,
      ),
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsController.themeMode,
            home: appState.when(
              data: (data) {
                if (!data.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const HomePage();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          );
        },
      ),
    );
  }
}
