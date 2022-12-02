import 'package:favocchi/model/message.dart';

class MessageConfig {
  // 他ユーザーの利用状況を知られるのを防ぐため、メッセージは具体的にしない
  static const String _emailCommon = 'メールアドレスが認識できません\n別のメールアドレスを入力してください';
  static const String _passwordCommon = 'パスワードに脆弱性があります\n別のパスワードを入力してください';
  static const String _loginErrCommon = 'ログインできませんでした\nメールアドレス、パスワードをご確認ください';

  // System側の問題
  static const String _sysErr = '通信エラーが発生いたしました\n時間を置いてやり直してください';

  // 想定外のエラー
  static MessageModel commonErr =
      MessageModel(message: _sysErr, sysMessage: '想定外エラー。');

  // バリデーション
  static MessageModel email = MessageModel(message: _emailCommon);
  static MessageModel password = MessageModel(message: _passwordCommon);
  static MessageModel required = MessageModel(message: '入力してください');
  static MessageModel minLength(length) {
    return MessageModel(message: '$length文字以上を入力してください');
  }

  static MessageModel maxLength(length) {
    return MessageModel(message: '$length文字以内で入力してください');
  }

  /// firebaseAuthで利用するメッセージ
  /// https://firebase.google.com/docs/reference/js/v8/firebase.auth.Auth
  /// https://firebase.google.com/docs/auth/admin/errors?hl=ja
  // 登録
  static MessageModel emailAlreadyInUse = MessageModel(
      message: '既に登録されています\nログイン画面からログインしてください',
      sysMessage: '既にfirebase.authで利用されているメールアドレス');
  static MessageModel invalidEmail = MessageModel(
      message: _emailCommon, sysMessage: 'firebase.authで認識できないメールアドレスの形式');
  static MessageModel operationNotAllowed = MessageModel(
      message: _sysErr, sysMessage: 'firebase.authの認証方法が誤っている', sysErr: true);
  static MessageModel weakPassword = MessageModel(
      message: _passwordCommon, sysMessage: 'firebase.authでパスワードの脆弱性を指摘された');
  // 更新
  static MessageModel equiresRecentLogin =
      MessageModel(message: _sysErr, sysMessage: 'firebase.authへのユーザー再認証が必要');

  // リセット・ログイン
  static MessageModel userNotFound = MessageModel(
      message: _loginErrCommon,
      sysMessage: 'firebase.authに登録されていないメールアドレスで操作をした');
  static MessageModel userNotFoundReset = MessageModel(
      message: _emailCommon,
      sysMessage: 'firebase.authに登録されていないメールアドレスでパスワードリセットを行った');
  static MessageModel wrongPasswordConfirm =
      MessageModel(message: 'パスワードが異なります\n入力し直してください', sysMessage: 'パスワードが異なる');
  // ログイン
  static MessageModel invalidCredential = MessageModel(
      message: _loginErrCommon,
      sysMessage: 'firebase.authの情報と一致しないか、有効期限が切れている');
  static MessageModel userDisabled = MessageModel(
      message: _loginErrCommon, sysMessage: 'firebase.authで無効にされたユーザー');
  static MessageModel wrongPassword =
      MessageModel(message: _loginErrCommon, sysMessage: 'ログインパスワードが異なる');
  static MessageModel tooManyRequests = MessageModel(
      message: 'アカウントロック中です\nロックが解除されるまで、しばらくお待ち下さい',
      sysMessage: 'パスワードを何度も間違えた');
  static MessageModel reSnedMail = MessageModel(message: '会員登録メールを再送しました。');
  static MessageModel errSendMail =
      MessageModel(message: _sysErr, sysMessage: 'メールが送信できなかった');

  // 完了メッセージ
  static MessageModel createAccountSend = MessageModel(
    message: 'メールに記載されているURLから、会員登録を完了してください。\n\n' +
        'URLの有効期限が過ぎた場合は、再度確認メールを送信してください。',
  );
  static MessageModel updateAccountSend = MessageModel(
    message: 'メールに記載されているURLから、更新を完了してください。\n\n' +
        'URLの有効期限が過ぎた場合は、ログインして確認メールを送信してください。',
  );
  static MessageModel updatePassword = MessageModel(message: 'パスワードを更新しました');
  static MessageModel resetPassword =
      MessageModel(message: 'パスワード再発行のメールを送りました');
}
