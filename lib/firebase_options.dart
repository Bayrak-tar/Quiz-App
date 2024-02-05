// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCXxagsYFbfMMx_UEEYfXtfBA9gSWMGbiM',
    appId: '1:184663112236:web:9bfbaa609abd3c78afef89',
    messagingSenderId: '184663112236',
    projectId: 'mobil-final-odev-7777c',
    authDomain: 'mobil-final-odev-7777c.firebaseapp.com',
    storageBucket: 'mobil-final-odev-7777c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD36lI8Lhz5fZWblzpV9rs0SfP7-TEUvgM',
    appId: '1:184663112236:android:cf64ee87ad889002afef89',
    messagingSenderId: '184663112236',
    projectId: 'mobil-final-odev-7777c',
    storageBucket: 'mobil-final-odev-7777c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2z-JtmszvflpEovQRcQknNtsL64FyHc4',
    appId: '1:184663112236:ios:b4779e7e570c7d13afef89',
    messagingSenderId: '184663112236',
    projectId: 'mobil-final-odev-7777c',
    storageBucket: 'mobil-final-odev-7777c.appspot.com',
    iosBundleId: 'com.example.mobilFinalOdevi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2z-JtmszvflpEovQRcQknNtsL64FyHc4',
    appId: '1:184663112236:ios:2d611b863ea20c90afef89',
    messagingSenderId: '184663112236',
    projectId: 'mobil-final-odev-7777c',
    storageBucket: 'mobil-final-odev-7777c.appspot.com',
    iosBundleId: 'com.example.mobilFinalOdevi.RunnerTests',
  );
}