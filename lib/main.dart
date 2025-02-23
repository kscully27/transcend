import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/modal/pages/root_sheet_page.dart';
import 'package:trancend/src/pages/demo.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/providers/theme_provider.dart';
import 'package:trancend/src/router/playground_route_information_parser.dart';
import 'package:trancend/src/router/playground_router_delegate.dart';
import 'package:trancend/src/theme/app_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_text_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme_data.dart';
import 'package:get/get.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/services/navigation.service.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  runMainApp(null);
}

void runMainApp(FirebaseOptions? firebaseOptions) async {
  print('Running main app');
  print('Firebase options: $firebaseOptions');
  
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    if (firebaseOptions != null) {
      print('Initializing Firebase with options...');
      await Firebase.initializeApp(options: firebaseOptions);
      print('Firebase initialized successfully');
    }
    
    print('Initializing AppColors...');
    await AppColors.initialize();
    print('AppColors initialized');
    
    print('Setting up locator...');
    await setupLocator();
    print('Locator setup complete');

    runApp(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            // Initialize app state
            final appState = ref.watch(appStateProvider);
            final isDarkMode = ref.watch(themeProvider);

            return appState.when(
              data: (data) {
                if (!data.isInitialized) {
                  return const MaterialApp(
                    home: Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
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
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  routeInformationParser: const PlaygroundRouteInformationParser(),
                  backButtonDispatcher: RootBackButtonDispatcher(),
                  routerDelegate: PlaygroundRouterDelegate(
                    ref: ref,
                    pageIndexNotifier: ValueNotifier(0),
                    pageListBuilderNotifier: ValueNotifier(
                      (context) => [RootSheetPage.build(context)],
                    ),
                  ),
                );
              },
              loading: () => const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stack) => MaterialApp(
                home: Scaffold(
                  body: Center(child: Text('Error: $error')),
                ),
              ),
            );
          },
        ),
      ),
    );
  } catch (e, stackTrace) {
    print('Error initializing Firebase: $e');
    print('Stack trace: $stackTrace');
  }
}
