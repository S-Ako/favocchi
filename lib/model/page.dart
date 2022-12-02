import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PageModel {
  String url;
  String title;
  Widget widget;
  IconData? icon;
  List<GetMiddleware>? middlewares;
  bool admin;
  bool special;
  bool autoFocus;

  PageModel(
      {required this.url,
      required this.title,
      required this.widget,
      this.icon,
      this.middlewares,
      this.admin = false,
      this.special = false,
      this.autoFocus = false});
}
