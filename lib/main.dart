import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trancend/src/locator.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void runMainApp(FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Set up the SettingsController
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();
    await Firebase.initializeApp(options: firebaseOptions);
    await setupLocator();
    runApp(MyApp(settingsController: settingsController));
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle initialization error appropriately
  }
}
