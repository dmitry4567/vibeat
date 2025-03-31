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
    apiKey: 'AIzaSyA2qjMrWR_ruVfxI3-ENRRCFJ2nw3PHYd0',
    appId: '1:81758102489:web:da08a044cbb4c781e62fc8',
    messagingSenderId: '81758102489',
    projectId: 'vibeat-c4318',
    authDomain: 'vibeat-c4318.firebaseapp.com',
    storageBucket: 'vibeat-c4318.firebasestorage.app',
    measurementId: 'G-FS8PT2XM9Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAukk0-aktqgNrINTECKrMX0fxeoGI4x1E',
    appId: '1:81758102489:android:12d9e860051aff98e62fc8',
    messagingSenderId: '81758102489',
    projectId: 'vibeat-c4318',
    storageBucket: 'vibeat-c4318.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBX-V506ALamU2lvnxuquT5bzwcm7Oz6oA',
    appId: '1:81758102489:ios:079e3a5a83a08197e62fc8',
    messagingSenderId: '81758102489',
    projectId: 'vibeat-c4318',
    storageBucket: 'vibeat-c4318.firebasestorage.app',
    iosBundleId: 'com.exsound.vibeat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBX-V506ALamU2lvnxuquT5bzwcm7Oz6oA',
    appId: '1:81758102489:ios:fce56ca17a64bfd9e62fc8',
    messagingSenderId: '81758102489',
    projectId: 'vibeat-c4318',
    storageBucket: 'vibeat-c4318.firebasestorage.app',
    iosBundleId: 'com.example.vibeat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA2qjMrWR_ruVfxI3-ENRRCFJ2nw3PHYd0',
    appId: '1:81758102489:web:c78527674cd6db6fe62fc8',
    messagingSenderId: '81758102489',
    projectId: 'vibeat-c4318',
    authDomain: 'vibeat-c4318.firebaseapp.com',
    storageBucket: 'vibeat-c4318.firebasestorage.app',
    measurementId: 'G-2GV6NDYJ45',
  );
}
