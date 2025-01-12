import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/providers/app_state_provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void runMainApp(FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();
    await Firebase.initializeApp(options: firebaseOptions);
    await setupLocator();
    
    runApp(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            // Initialize app state
            ref.watch(appStateProvider);
            return MyApp(settingsController: settingsController);
          },
        ),
      ),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}
