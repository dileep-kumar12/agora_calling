
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if(Platform.isIOS){
      return const FirebaseOptions(
          apiKey: "AIzaSyBtZRynJb0Xrmc0sNQK8iPiNI1DAo9mT3g",
          appId: "1:438852967694:ios:bc988638879033ba9acb5f",
          messagingSenderId: "438852967694",
          projectId: "agora-voice-calling-78ed2",
          storageBucket: "agora-voice-calling-78ed2.appspot.com"
      );
    } else {
      return const FirebaseOptions(
          apiKey: "AIzaSyDD6l2QmwOpOG18-fqdXwZBqFeOFwBsXjs",
          appId: "1:438852967694:android:42e5cd392de573d49acb5f",
          messagingSenderId: "438852967694",
          projectId: "agora-voice-calling-78ed2",
          storageBucket: "agora-voice-calling-78ed2.appspot.com"
      );
    }
  }
}