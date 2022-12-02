import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';

class InitFirebase {
  static Future<bool> connection() async {
    // if (Firebase.apps.length != 0) return false;
    //firebase 接続準備
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  }
}
