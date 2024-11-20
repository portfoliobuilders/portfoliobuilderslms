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
    apiKey: 'AIzaSyAJha2524sPyqsVuMfkzAhyZOvHDYkn1P4',
    appId: '1:52436006512:web:72990d28bfc7f6543f66b5',
    messagingSenderId: '52436006512',
    projectId: 'portfoliobuilderslms-f693e',
    authDomain: 'portfoliobuilderslms-f693e.firebaseapp.com',
    storageBucket: 'portfoliobuilderslms-f693e.firebasestorage.app',
    measurementId: 'G-DWW6JY9QW6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAo4B936u_KK6cgmXcWeQk844WIET72yq0',
    appId: '1:52436006512:android:ea85640acdd834713f66b5',
    messagingSenderId: '52436006512',
    projectId: 'portfoliobuilderslms-f693e',
    storageBucket: 'portfoliobuilderslms-f693e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgvdURTJLH16uIakbDkHibvfr_p1AtGN4',
    appId: '1:52436006512:ios:0ac82850d8f248693f66b5',
    messagingSenderId: '52436006512',
    projectId: 'portfoliobuilderslms-f693e',
    storageBucket: 'portfoliobuilderslms-f693e.firebasestorage.app',
    iosBundleId: 'com.example.portfoliobuilderslms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgvdURTJLH16uIakbDkHibvfr_p1AtGN4',
    appId: '1:52436006512:ios:0ac82850d8f248693f66b5',
    messagingSenderId: '52436006512',
    projectId: 'portfoliobuilderslms-f693e',
    storageBucket: 'portfoliobuilderslms-f693e.firebasestorage.app',
    iosBundleId: 'com.example.portfoliobuilderslms',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJha2524sPyqsVuMfkzAhyZOvHDYkn1P4',
    appId: '1:52436006512:web:165b4da4de5f6f593f66b5',
    messagingSenderId: '52436006512',
    projectId: 'portfoliobuilderslms-f693e',
    authDomain: 'portfoliobuilderslms-f693e.firebaseapp.com',
    storageBucket: 'portfoliobuilderslms-f693e.firebasestorage.app',
    measurementId: 'G-YS8C7W9M18',
  );

}