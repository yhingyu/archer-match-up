import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'your-web-api-key',
    appId: '1:your-project-number:web:your-web-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'archer-match-up',
    authDomain: 'archer-match-up.firebaseapp.com',
    storageBucket: 'archer-match-up.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-android-api-key',
    appId: '1:your-project-number:android:your-android-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'archer-match-up',
    storageBucket: 'archer-match-up.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: '1:your-project-number:ios:your-ios-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'archer-match-up',
    storageBucket: 'archer-match-up.appspot.com',
    iosBundleId: 'com.archery.matchup.archerMatchUp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your-macos-api-key',
    appId: '1:your-project-number:ios:your-macos-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'archer-match-up',
    storageBucket: 'archer-match-up.appspot.com',
    iosBundleId: 'com.archery.matchup.archerMatchUp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'your-windows-api-key',
    appId: '1:your-project-number:web:your-windows-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'archer-match-up',
    authDomain: 'archer-match-up.firebaseapp.com',
    storageBucket: 'archer-match-up.appspot.com',
  );
}