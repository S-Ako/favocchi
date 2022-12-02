import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/message.dart';
import '../../config/routes.dart';
import '../../utils/font.dart';
import '../../utils/scaffold.dart';
import '../../utils/space.dart';

class MailSendAccountPage extends StatefulWidget {
  const MailSendAccountPage({Key? key}) : super(key: key);
  @override
  State<MailSendAccountPage> createState() => _MailSendAccountPage();
}

class _MailSendAccountPage extends State<MailSendAccountPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldUtils.defaultPage(
        RoutesConfig.mailSendAccount,
        Column(
          children: [
            FontUtils.bodyTitle('登録はまだ終わっていません'),
            SpaceUtils.bigY,
            FontUtils.bodyMsg(MessageConfig.createAccountSend.message),
            SpaceUtils.bigY,
            SpaceUtils.bigY,
            TextButton.icon(
              icon: const Icon(Icons.login),
              label: FontUtils.secondColorText(
                'ログインはこちらから',
              ),
              onPressed: () {
                Get.offNamed(RoutesConfig.loginAccount.url);
              },
            )
          ],
        ));
  }
}
