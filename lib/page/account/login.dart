import 'package:flutter/material.dart';
import '../../config/common.dart';
import '../../firebase/auth.dart';
import 'package:get/get.dart';
import '../../config/message.dart';
import '../../config/routes.dart';
import '../../page/account/common.dart';
import '../../utils/space.dart';

class LoginAccountPage extends StatefulWidget {
  const LoginAccountPage({Key? key}) : super(key: key);
  @override
  State<LoginAccountPage> createState() => _LoginAccountPage();
}

class _LoginAccountPage extends State<LoginAccountPage> {
  static final CommonAcountPage _commonAcountPage = CommonAcountPage();

  @override
  Widget build(BuildContext context) {
    return _commonAcountPage.accountForm(
        RoutesConfig.loginAccount, 'ログイン', _LoginAccountPage.buttonClick,
        login: true,
        bottomArea: [
          SpaceUtils.bigY,
          _commonAcountPage.createAccountButton,
          SpaceUtils.smallY,
          _commonAcountPage.passwordAccountButton,
        ]);
  }

  static void buttonClick() async {
    bool result = await AuthFirebase.login(
        _commonAcountPage.email, _commonAcountPage.password);
    if (result) {
      // CommonConfig.showSnackBar('ログインしました');
      Get.toNamed(RoutesConfig.home.url);
    } else {
      CommonConfig.showSnackBar(AuthFirebase.endMessage);
      if (AuthFirebase.endMessage == MessageConfig.reSnedMail.message) {
        CommonAcountPage.writingEmail = _commonAcountPage.email;
        Get.toNamed(RoutesConfig.mailSendAccount.url);
      }
    }
  }
}
