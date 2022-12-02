import 'package:favocchi/utils/font.dart';
import 'package:flutter/material.dart';

import '../../config/common.dart';
import '../../firebase/auth.dart';
import 'package:get/get.dart';
import '../../config/message.dart';
import '../../config/routes.dart';
import '../../page/account/common.dart';
import '../../utils/space.dart';

class PasswordAccountPage extends StatefulWidget {
  const PasswordAccountPage({Key? key}) : super(key: key);
  @override
  State<PasswordAccountPage> createState() => _PasswordAccountPage();
}

class _PasswordAccountPage extends State<PasswordAccountPage> {
  static final CommonAcountPage _commonAcountPage = CommonAcountPage();
  @override
  Widget build(BuildContext context) {
    return _commonAcountPage.accountForm(
        RoutesConfig.passwordAccount, '送信', _PasswordAccountPage.buttonClick,
        passwordArea: false,
        bottomArea: [
          SpaceUtils.smallY,
          FontUtils.body1('登録したEmail宛に、パスワードリセットのメールを送ります。'),
          SpaceUtils.bigY,
          _commonAcountPage.loginAccountButton,
          SpaceUtils.smallY,
          _commonAcountPage.createAccountButton,
        ]);
  }

  static void buttonClick() async {
    bool result = await AuthFirebase.resetPassword(_commonAcountPage.email);
    if (result) {
      CommonConfig.showSnackBar(MessageConfig.resetPassword.message);
      CommonAcountPage.writingEmail = _commonAcountPage.email;
      Get.toNamed(RoutesConfig.home.url);
    } else {
      CommonConfig.showSnackBar(AuthFirebase.endMessage);
      // if (AuthFirebase.endMessage == MessageConfig.reSnedMail.message) {
      //   Get.toNamed(RoutesConfig.mailSendAccount.url);
      // }
    }
  }
}
