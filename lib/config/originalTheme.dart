import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favocchi/config/common.dart';

class OriginalTheme {
  const OriginalTheme._internal();

  static const MaterialColor _primary = Colors.indigo;
  static const MaterialAccentColor _accent = Colors.amberAccent;

  static final ThemeData blue = ThemeData(
    // font
    fontFamily: CommonConfig.fontFamily,
    //AppBar, Card, FAB(FloatingActionButton), ElevatedButton
    useMaterial3: true,
    colorSchemeSeed: Colors.blueGrey,
    brightness: Brightness.light,
  );
}
