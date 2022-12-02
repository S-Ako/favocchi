import 'package:firebase_auth/firebase_auth.dart';

import '../config/common.dart';
import '../config/message.dart';
import 'db/user.dart';

class AuthFirebase {
  static String endMessage = '';
  static late User userInfo;

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> userDelete(User user) async {
    try {
      await user.delete();
      return true;
    } catch (e) {
      print('$e');
      endMessage = MessageConfig.commonErr.message;
      return false;
    }
  }

  static Future<bool> updateEmail(
      User user, String newEmail, String password) async {
    endMessage = '';
    // 再認証
    if (!await getCredential(user, password)) {
      return false;
    }
    // Email更新
    if (!await _updateEmail(user, newEmail)) {
      return false;
    }
    // メール送信
    if (!await _sendEmail(FirebaseAuth.instance.currentUser!)) {
      return false;
    }
    return true;
  }

  static Future<bool> updatePassword(
      User user, String password, String newPassword) async {
    endMessage = '';
    // 再認証
    if (!await getCredential(user, password)) {
      return false;
    }
    // パスワード更新
    if (!await _updatePassword(user, newPassword)) {
      return false;
    }
    return true;
  }

  static Future<bool> resetPassword(String email) async {
    endMessage = '';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          endMessage = MessageConfig.invalidEmail.message;
          break;
        case 'user-not-found':
          endMessage = MessageConfig.userNotFoundReset.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
      }
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    endMessage = '';
    if (!await _login(email, password)) {
      return false;
    }
    // メール認証済み(テストユーザーは認証不要)
    if (userInfo.emailVerified || email == CommonConfig.testUser) {
      return true;
    }
    // メール再送
    if (!await _sendEmail(userInfo)) {
      return false;
    }
    // 再送メッセージ
    endMessage = MessageConfig.reSnedMail.message;
    return false;
  }

  static Future<bool> create(String email, String password, String name) async {
    endMessage = '';
    if (!await _create(email, password)) {
      return false;
    }
    // UserDBFirestore user = UserDBFirestore(uid: userInfo.uid, name: name);
    userInfo.updateDisplayName(name);
    UserDBFirestore.createUser(userInfo.uid, name, '');
    if (!await _sendEmail(userInfo)) {
      return false;
    }
    return true;
  }

  static Future<bool> _create(String email, String password) async {
    try {
      final userWithEmailAndPassword =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      userInfo = userWithEmailAndPassword.user!;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          endMessage = MessageConfig.emailAlreadyInUse.message;
          break;
        case 'invalid-email':
          endMessage = MessageConfig.invalidEmail.message;
          break;
        case 'operation-not-allowed':
          endMessage = MessageConfig.operationNotAllowed.message;
          break;
        case 'weak-password':
          endMessage = MessageConfig.weakPassword.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
      }

      print(e);
      return false;
    }
  }

  static Future<bool> getCredential(User user, String password) async {
    final credential =
        EmailAuthProvider.credential(email: user.email!, password: password);
    try {
      // final credential =
      //     EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'too-many-requests':
          endMessage = MessageConfig.tooManyRequests.message;
          break;
        case 'wrong-password':
          endMessage = MessageConfig.wrongPasswordConfirm.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
          break;
      }
      print(e);
      return false;
    }
  }

  static Future<bool> _updatePassword(User user, String password) async {
    try {
      await user.updatePassword(password);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          endMessage = MessageConfig.invalidEmail.message;
          break;
        case 'email-already-in-use':
          endMessage = MessageConfig.emailAlreadyInUse.message;
          break;
        case 'operation-not-allowed':
          endMessage = MessageConfig.operationNotAllowed.message;
          break;
        case 'weak-password':
          endMessage = MessageConfig.weakPassword.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
      }

      print(e);
      return false;
    }
  }

  static Future<bool> _updateEmail(User user, String email) async {
    try {
      await user.updateEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          endMessage = MessageConfig.invalidEmail.message;
          break;
        case 'email-already-in-use':
          endMessage = MessageConfig.emailAlreadyInUse.message;
          break;
        case 'operation-not-allowed':
          endMessage = MessageConfig.operationNotAllowed.message;
          break;
        case 'weak-password':
          endMessage = MessageConfig.weakPassword.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
      }

      print(e);
      return false;
    }
  }

  static Future<bool> _login(String email, String password) async {
    try {
      final userWithEmailAndPassword =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      userInfo = userWithEmailAndPassword.user!;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          endMessage = MessageConfig.invalidEmail.message;
          break;
        case 'invalid-credential':
          endMessage = MessageConfig.invalidCredential.message;
          break;
        case 'user-disabled':
          endMessage = MessageConfig.userDisabled.message;
          break;
        case 'user-not-found':
          endMessage = MessageConfig.userNotFound.message;
          break;
        case 'wrong-password':
          endMessage = MessageConfig.wrongPassword.message;
          break;
        case 'too-many-requests':
          endMessage = MessageConfig.tooManyRequests.message;
          break;
        default:
          endMessage = MessageConfig.commonErr.message;
      }

      print(e);
      return false;
    }
  }

  static Future<bool> _sendEmail(User user) async {
    try {
      // idToken更新
      await user.getIdToken(true);
      // 確認メール送信
      await user.sendEmailVerification();
      return true;
    } catch (e) {
      endMessage = MessageConfig.errSendMail.message;
      return false;
    }
  }
}
