import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAg8lfBrHbFc6JR76unr7H52tfdVJ4ksew",
    authDomain: "workout-log-sync.firebaseapp.com",
    projectId: "workout-log-sync",
    storageBucket: "workout-log-sync.firebasestorage.app",
    messagingSenderId: "149427565389",
    appId: "1:149427565389:web:acfdc6b4514ca8e65a7d04",
    measurementId: "G-MZZN767G23",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "YOUR_ANDROID_API_KEY",
    appId: "YOUR_ANDROID_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "YOUR_IOS_API_KEY",
    appId: "YOUR_IOS_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    iosClientId: "YOUR_IOS_CLIENT_ID",
    iosBundleId: "YOUR_IOS_BUNDLE_ID",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "YOUR_MACOS_API_KEY",
    appId: "YOUR_MACOS_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    iosClientId: "YOUR_MACOS_CLIENT_ID",
    iosBundleId: "YOUR_MACOS_BUNDLE_ID",
  );
}
