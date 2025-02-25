// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDlHul0SiyN7g8VAhpkcYbPZU3vfa0qoj8',
    appId: '1:767721171003:web:b4e2a76d5d032ed585d41e',
    messagingSenderId: '767721171003',
    projectId: 'trancend-dev',
    authDomain: 'trancend-dev.firebaseapp.com',
    storageBucket: 'trancend-dev.firebasestorage.app',
    measurementId: 'G-7849XB0R55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTNimAlxOVp8tXARJGHxIYyqo2U7fXV5g',
    appId: '1:767721171003:android:280f923e20c32f0b85d41e',
    messagingSenderId: '767721171003',
    projectId: 'trancend-dev',
    storageBucket: 'trancend-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAD876uKQdeg0S4uovCyF-gsBg-vj3poOc',
    appId: '1:767721171003:ios:67af380fdb17c20485d41e',
    messagingSenderId: '767721171003',
    projectId: 'trancend-dev',
    storageBucket: 'trancend-dev.firebasestorage.app',
    iosBundleId: 'app.trancend.dev',
  );
}
