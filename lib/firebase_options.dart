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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyALJpa_ABbXgbBdh7b2sXnBbBjL_Kc4bO0',
    appId: '1:633799358940:web:073d0c78266186015b7719',
    messagingSenderId: '633799358940',
    projectId: 'projeto-pe-express-rota-347910',
    authDomain: 'projeto-pe-express-rota-347910.firebaseapp.com',
    storageBucket: 'projeto-pe-express-rota-347910.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6Xh7-KDjvLQJBI56op1pObG547Y95qZU',
    appId: '1:633799358940:android:c429146be94b31fb5b7719',
    messagingSenderId: '633799358940',
    projectId: 'projeto-pe-express-rota-347910',
    storageBucket: 'projeto-pe-express-rota-347910.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5EsSyNiPWxap3Joabbo-BgJQDWd_8CuI',
    appId: '1:633799358940:ios:f873ef18be1354175b7719',
    messagingSenderId: '633799358940',
    projectId: 'projeto-pe-express-rota-347910',
    storageBucket: 'projeto-pe-express-rota-347910.appspot.com',
    iosClientId: '633799358940-h25cdtkl36qjkl232cdvog94u1n0m414.apps.googleusercontent.com',
    iosBundleId: 'com.peexpress.cadastrorotas',
  );
}
