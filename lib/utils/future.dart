import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FutureUtils {
  static Future<void> awaitLate([int milliseconds = 300]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static Function awaitStart() {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
    EasyLoading.show(status: 'wating...', maskType: EasyLoadingMaskType.clear);
    return EasyLoading.dismiss;
  }
}
