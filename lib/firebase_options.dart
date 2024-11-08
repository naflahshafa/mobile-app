// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyC0V_g4BO-YNW8X4iy2llXbXM2kn9sPPvQ',
    appId: '1:758465058899:web:331596e28a7cb1482ccea6',
    messagingSenderId: '758465058899',
    projectId: 'papb-project-d9e27',
    authDomain: 'papb-project-d9e27.firebaseapp.com',
    storageBucket: 'papb-project-d9e27.appspot.com',
    measurementId: 'G-JHFXECJ40W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAELsRbIZh6sbWoHUpbwi-ajr77jG-6MUo',
    appId: '1:758465058899:android:d9ab879ce4dcacf42ccea6',
    messagingSenderId: '758465058899',
    projectId: 'papb-project-d9e27',
    storageBucket: 'papb-project-d9e27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZbxEsdXhQouebbFOginup6UI4V-bvtFk',
    appId: '1:758465058899:ios:d6c418204beec81e2ccea6',
    messagingSenderId: '758465058899',
    projectId: 'papb-project-d9e27',
    storageBucket: 'papb-project-d9e27.appspot.com',
    iosBundleId: 'com.example.petNotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZbxEsdXhQouebbFOginup6UI4V-bvtFk',
    appId: '1:758465058899:ios:d6c418204beec81e2ccea6',
    messagingSenderId: '758465058899',
    projectId: 'papb-project-d9e27',
    storageBucket: 'papb-project-d9e27.appspot.com',
    iosBundleId: 'com.example.petNotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC0V_g4BO-YNW8X4iy2llXbXM2kn9sPPvQ',
    appId: '1:758465058899:web:504565739018a27e2ccea6',
    messagingSenderId: '758465058899',
    projectId: 'papb-project-d9e27',
    authDomain: 'papb-project-d9e27.firebaseapp.com',
    storageBucket: 'papb-project-d9e27.appspot.com',
    measurementId: 'G-CFKYL2JB7H',
  );
}
