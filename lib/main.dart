import 'package:flutter/material.dart';
import 'package:trancend/src/locator.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase with the generated options
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Setup service locator after Firebase is initialized
    await setupLocator();

    // Set up the SettingsController
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    runApp(MyApp(settingsController: settingsController));
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle initialization error appropriately
  }
}
