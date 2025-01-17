import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/providers/app_state_provider.dart';
import 'package:trancend/src/providers/theme_provider.dart';

import 'src/app.dart';
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
            ref.watch(appStateProvider);
            final isDarkMode = ref.watch(themeProvider);
            return MyApp(
              settingsController: settingsController,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
