import 'package:flutter/material.dart';

import '../../config/common.dart';
import '../../firebase/auth.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';
import '../../page/account/common.dart';
import '../../utils/space.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);
  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  static final CommonAcountPage _commonAcountPage = CommonAcountPage();
  @override
  Widget build(BuildContext context) {
    return _commonAcountPage.accountForm(
        RoutesConfig.createAccount, '登録', _CreateAccountPage.buttonClick,
        nameArea: true,
        bottomArea: [SpaceUtils.smallY, _commonAcountPage.loginAccountButton]);
  }

  static void buttonClick() async {
    bool result = await AuthFirebase.create(_commonAcountPage.email,
        _commonAcountPage.password, _commonAcountPage.name);
    if (result) {
      CommonAcountPage.writingEmail = _commonAcountPage.email;
      Get.toNamed(RoutesConfig.mailSendAccount.url);
    } else {
      CommonConfig.showSnackBar(AuthFirebase.endMessage);
    }
  }
}
