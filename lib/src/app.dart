import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/pages/demo.dart';
import 'package:trancend/src/pages/home_screen.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/services/navigation.service.dart';
import 'package:trancend/src/theme/app_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_text_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme_data.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    this.themeMode,
  });

  final SettingsController settingsController;
  final ThemeMode? themeMode;

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
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: locator<NavigationService>().navigatorKey,
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
            themeMode: themeMode ?? settingsController.themeMode,
            home: appState.when(
              data: (data) {
                if (!data.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const HomeScreen();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            getPages: [
              GetPage(
                name: DemoPage.routeName,
                page: () => const DemoPage(),
                transition: Transition.fade,
              ),
            ],
          );
        },
      ),
    );
  }
}
