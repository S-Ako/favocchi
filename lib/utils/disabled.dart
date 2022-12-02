import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisabledUtils {
  static RxBool isEnableRx = RxBool(true);
  static Future<void> waitEnable([int waitTime = 1]) async {
    await Future.delayed(
      Duration(seconds: waitTime),
    );
    isEnableRx.value = true;
  }

  // static Future<void> enableButton(ElevatedButton widget) async {
  //   Function()? _func = widget.onPressed;
  //   Obx(() {
  //     widget.
  //     widget.onPressed = null;
  //     return widget;
  //   });
  // }
}
