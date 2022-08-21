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
    apiKey: 'AIzaSyD7m_QMd7KwR-8m1lgMAzn5LeMibsTCI5A',
    appId: '1:749553275010:web:aa11a7955d35aba681a49b',
    messagingSenderId: '749553275010',
    projectId: 'group-planner-d4826',
    authDomain: 'group-planner-d4826.firebaseapp.com',
    storageBucket: 'group-planner-d4826.appspot.com',
    measurementId: 'G-TEK2FKBF1F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBntQ8dI3v0cdUjIy3POqScwgcvURrsmLw',
    appId: '1:749553275010:android:d704dda359e7b86881a49b',
    messagingSenderId: '749553275010',
    projectId: 'group-planner-d4826',
    storageBucket: 'group-planner-d4826.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHI8nYWcGMY8NV0IzObSBWOC2oI9YhR7w',
    appId: '1:749553275010:ios:454b5e9129b78f7981a49b',
    messagingSenderId: '749553275010',
    projectId: 'group-planner-d4826',
    storageBucket: 'group-planner-d4826.appspot.com',
    iosClientId: '749553275010-26qaksqa0klor3fpjtba7fe5ftdbauon.apps.googleusercontent.com',
    iosBundleId: 'net.blasix.groupPlannerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHI8nYWcGMY8NV0IzObSBWOC2oI9YhR7w',
    appId: '1:749553275010:ios:454b5e9129b78f7981a49b',
    messagingSenderId: '749553275010',
    projectId: 'group-planner-d4826',
    storageBucket: 'group-planner-d4826.appspot.com',
    iosClientId: '749553275010-26qaksqa0klor3fpjtba7fe5ftdbauon.apps.googleusercontent.com',
    iosBundleId: 'net.blasix.groupPlannerApp',
  );
}
