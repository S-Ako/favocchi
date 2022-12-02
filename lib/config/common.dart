import 'package:favocchi/utils/font.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firebase/db/user.dart';

class CommonConfig {
  static String testUser = 'test@example.com';
  static bool testing = true;
  static UserDBFirestore? mine;
  static String title = 'favocchi';
  static String fontFamily = 'ZenKakuGothicAntique';
  static String appIconPath = 'assets/images/app_icon.png';
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String text) {
    return scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: FontUtils.body1(
        text,
        // textAlign: TextAlign.end,
      ),
    ));
  }

  static defaultSnackbar(String title, String message) {
    Get.snackbar(
      title, message,
      colorText: Colors.black87,
      duration: Duration(seconds: 5),
      // snackPosition: SnackPosition.BOTTOM,
      snackPosition: SnackPosition.TOP,
      titleText: FontUtils.body1Bold(title),
      messageText: FontUtils.body1(message),
      // snackStyle: SnackStyle.FLOATING,
      // margin: EdgeInsets.only(bottom: 80)
    );
  }

  static betaSnackbar(String noUse) {
    String title = 'ベータ版';
    String message = 'ベータ版のため、$noUseは使用できません';
    defaultSnackbar(title, message);
  }

  static noPaidSnackbar(String noUse) {
    String title = 'ご利用ありがとうございます';
    String message = '無料版使用のため、$noUseは使用できません\n引き続き無料版をお楽しみください';
    defaultSnackbar(title, message);
  }

  static noPaidSnackbar2(String str) {
    String title = 'ご利用ありがとうございます';
    String message = '無料版使用のため、$str\n引き続き無料版をお楽しみください';
    defaultSnackbar(title, message);
  }

  static testSnackbar(String noUse) {
    String title = 'テストユーザー';
    String message = 'テストユーザーのため、$noUseは使用できません';
    defaultSnackbar(title, message);
  }

  static const int minPasswordLength = 8;
  static const int maxAcountNameLength = 32;
  static const int maxTitleLength = 20;
  static late BuildContext? _mainContext;
  // static const primaryColor = Colors.yellow; //Colors.indigo;
  // static const secondaryColor = Colors.red; //Colors.lightBlue;
  static const double defaultContentMaxWidth = 1200;
  static const double defaultFormMaxWidth = 800;
  static const double toggleFormMaxWidth = 400;
  static const double toggleFormMinWidth = 2000;

  BuildContext get mainContext => _mainContext!;
  set mainContext(BuildContext context) {
    _mainContext = context;
  }

  static MimeType getMimeType(String type) {
    switch (type) {
      case 'video/x-msvideo':
        return MimeType.AVI;
      case 'audio/aac':
        return MimeType.AAC;
      case 'image/bmp':
        return MimeType.BMP;
      case 'application/epub+zip':
        return MimeType.EPUB;
      case 'image/gif':
        return MimeType.GIF;
      case 'application/json':
        return MimeType.JSON;
      case 'video/mpeg':
        return MimeType.MPEG;
      case 'audio/mpeg':
        return MimeType.MP3;
      case 'image/jpeg':
        return MimeType.JPEG;
      case 'font/otf':
        return MimeType.OTF;
      case 'image/png':
        return MimeType.PNG;
      case 'application/vnd.oasis.opendocument.presentation':
        return MimeType.OPENDOCPRESENTATION;
      case 'application/vnd.oasis.opendocument.text':
        return MimeType.OPENDOCTEXT;
      case 'application/vnd.oasis.opendocument.spreadsheet':
        return MimeType.OPENDOCSHEETS;
      case 'application/pdf':
        return MimeType.PDF;
      case 'font/ttf':
        return MimeType.TTF;
      case 'application/zip':
        return MimeType.ZIP;
      case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
        return MimeType.MICROSOFTEXCEL;
      case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
        return MimeType.MICROSOFTPRESENTATION;
      case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
        return MimeType.MICROSOFTWORD;
      case "application/vnd.etsi.asic-e+zip":
        return MimeType.ASICE;
      case "application/vnd.etsi.asic-s+zip":
        return MimeType.ASICS;
      case "application/vnd.etsi.asic-e+zip":
        return MimeType.BDOC;
      case "application/octet-stream":
        return MimeType.OTHER;
      case 'text/plain':
        return MimeType.TEXT;
      case 'text/csv':
        return MimeType.CSV;
      default:
        return MimeType.OTHER;
    }
  }
}
