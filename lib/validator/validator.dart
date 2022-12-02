import '../config/common.dart';
import '../config/message.dart';

class Validator {
  /// 入力値の存在を確認
  static bool _isInput(val) {
    return (val != null && val.isNotEmpty);
  }

  /// 必須入力チェック
  static String? required(String? text) {
    if (_isInput(text)) {
      return null;
    }
    return MessageConfig.required.message;
  }

  /// ニックネームチェック
  static String? accountName(String? text) {
    for (Function f in [required, maxLength]) {
      String? errMsg = f != maxLength
          ? f(text)
          : maxLength(text, CommonConfig.maxAcountNameLength);
      if (errMsg != null) {
        return errMsg;
      }
    }
    return null;
  }

  /// メールアドレスチェック
  /// ログイン・新規作成・再設定
  static String? accountEmail(String? text) {
    for (Function f in [required, email]) {
      String? errMsg = f(text);
      if (errMsg != null) {
        return errMsg;
      }
    }
    return null;
  }

  /// パスワード
  static String? newPassword(String? text) {
    for (Function f in [required, minLength]) {
      String? errMsg = f != minLength
          ? f(text)
          : minLength(text, CommonConfig.minPasswordLength);
      if (errMsg != null) {
        return errMsg;
      }
    }
    return null;
  }

  /// 記事タイトル
  static String? settingTitle(String? text) {
    for (Function f in [required, maxLength]) {
      String? errMsg = f != maxLength
          ? f(text)
          : maxLength(text, CommonConfig.maxTitleLength);
      if (errMsg != null) {
        return errMsg;
      }
    }
    return null;
  }

  /// メールアドレス形式チェック
  /// https://www.javadrive.jp/regex-basic/sample/index13.html
  static String? email(String? text) {
    if (_isInput(text)) {
      String pattern =
          r'^[a-zA-Z0-9_+-]+(.[a-zA-Z0-9_+-]+)*@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(text!)) {
        return MessageConfig.email.message;
      }
    }
    return null;
  }

  /// 最低文字数チェック
  static String? minLength(String? text, int length) {
    if (_isInput(text)) {
      if (text!.length < length) {
        return MessageConfig.minLength(length).message;
      }
    }
    return null;
  }

  /// 最大文字数チェック
  static String? maxLength(String? text, int length) {
    if (_isInput(text)) {
      if (text!.length > length) {
        return MessageConfig.maxLength(length).message;
      }
    }
    return null;
  }
}
