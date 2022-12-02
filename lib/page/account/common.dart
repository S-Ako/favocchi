import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:favocchi/utils/button.dart';

import '../../config/common.dart';
import '../../config/routes.dart';
import '../../model/page.dart';
import '../../utils/future.dart';
import '../../utils/font.dart';
import '../../utils/scaffold.dart';
import '../../utils/space.dart';
import '../../validator/validator.dart';

final ThemeData _theme = Theme.of(CommonConfig().mainContext);

class CommonAcountPage {
  static String writingEmail = '';
  late RxBool isPassShowRx;
  late RxBool isTryRx;
  late GlobalKey<FormState> formKey;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String get email => emailController.text;
  String get password => passwordController.text;
  String get name => nameController.text;

  Widget accountForm(PageModel page, String buttonName, Function buttonFunction,
      {bool nameArea = false,
      bool passwordArea = true,
      List<Widget>? bottomArea,
      bool login = false}) {
    isPassShowRx = RxBool(false);
    isTryRx = RxBool(false);
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = login
        ? TextEditingController(text: writingEmail)
        : TextEditingController();
    writingEmail = '';

    List<Widget> nameAreaList = nameArea ? [_inputName, SpaceUtils.bigY] : [];
    List<Widget> passwordAreaList =
        passwordArea ? [_inputPassword(login), SpaceUtils.bigY] : [];

    return ScaffoldUtils.appTitlePage(
        page,
        Form(
            key: formKey,
            child: ScaffoldUtils.maxCenterBox(
                Column(
                  children: [
                    ...nameAreaList,
                    _inputEmail,
                    SpaceUtils.bigY,
                    ...passwordAreaList,
                    _button(buttonName, buttonFunction),
                    Column(
                      children: bottomArea ?? [Container()],
                    )
                  ],
                ),
                maxWidth: CommonConfig.defaultFormMaxWidth)));
  }

  late Obx _inputName = Obx(() => TextFormField(
        autofocus: true,
        autovalidateMode: isTryRx.value
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: nameController,
        validator: Validator.accountName,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(filled: true, hintText: 'ニックネーム'),
      ));

  late Obx _inputEmail = Obx(() => TextFormField(
        autofocus: true,
        autovalidateMode: isTryRx.value
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: emailController,
        validator: Validator.accountEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(filled: true, hintText: 'メールアドレス'),
      ));

  Obx _inputPassword([bool login = false]) {
    return Obx(() => TextFormField(
          autovalidateMode: isTryRx.value
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          controller: passwordController,
          validator: login ? Validator.required : Validator.newPassword,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            filled: true,
            hintText: 'パスワード',
            //TextFormFieldの右側にアイコンを表示
            suffixIcon: IconButton(
              icon: Icon(
                isPassShowRx.value ? Icons.visibility : Icons.visibility_off,
                color: _theme.colorScheme.primary,
              ),
              onPressed: () {
                isPassShowRx.value = !isPassShowRx.value;
              },
            ),
          ),
          obscureText: !isPassShowRx.value,
        ));
  }

  ElevatedButton _button(String buttonName, Function action) {
    return ElevatedButton(
      style: ButtonUtils.buttonStyle,
      onPressed: () async {
        Function awaitEnd = FutureUtils.awaitStart();
        isTryRx.value = true;
        if (!formKey.currentState!.validate()) {
          awaitEnd();
          return;
        }
        await action();
        await FutureUtils.awaitLate();
        awaitEnd();
      },
      child: Text(buttonName),
    );
  }

  TextButton createAccountButton = TextButton.icon(
    icon: Icon(
      RoutesConfig.createAccount.icon ?? Icons.person_add,
      color: _theme.colorScheme.primary,
    ),
    label: FontUtils.secondColorText(
      '会員登録はこちらから',
    ),
    onPressed: () {
      Get.toNamed(RoutesConfig.createAccount.url);
    },
  );

  TextButton loginAccountButton = TextButton.icon(
    icon: Icon(
      RoutesConfig.loginAccount.icon ?? Icons.password,
      color: _theme.colorScheme.primary,
    ),
    label: FontUtils.secondColorText(
      'ログインはこちらから',
    ),
    onPressed: () {
      Get.toNamed(RoutesConfig.loginAccount.url);
    },
  );
  TextButton passwordAccountButton = TextButton.icon(
    icon: Icon(
      RoutesConfig.passwordAccount.icon ?? Icons.password,
      color: _theme.colorScheme.primary,
    ),
    label: FontUtils.secondColorText(
      'パスワードを忘れた方はこちらから',
    ),
    onPressed: () {
      Get.toNamed(RoutesConfig.passwordAccount.url);
    },
  );
}
