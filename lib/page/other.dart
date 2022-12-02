import 'package:favocchi/config/common.dart';
import 'package:favocchi/config/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:favocchi/utils/button.dart';
import '../../config/routes.dart';
import '../../utils/scaffold.dart';
import '../firebase/auth.dart';
import '../firebase/db/leave_log.dart';
import '../utils/future.dart';
import '../utils/font.dart';
import '../utils/space.dart';
import '../validator/validator.dart';

late BuildContext _context;
final ThemeData _theme = Theme.of(CommonConfig().mainContext);

class OtherPage extends StatefulWidget {
  const OtherPage({Key? key}) : super(key: key);
  @override
  State<OtherPage> createState() => _OtherPage();
}

class _OtherPage extends State<OtherPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ScaffoldUtils.defaultPage(
        RoutesConfig.other,
        Column(children: [
          ScaffoldUtils.maxCenterBox(
              Column(
                children: [
                  _InputEmail().form,
                  SpaceUtils.bigY,
                  _InputPassword().form,
                ],
              ),
              maxWidth: CommonConfig.defaultFormMaxWidth),
          SpaceUtils.bigY,
          _logoutButton,
          SpaceUtils.bigY,
          SpaceUtils.bigY,
          _deleteButton
        ]));
  }

  static TextButton _deleteButton = TextButton.icon(
      icon: Icon(FontAwesomeIcons.personCircleExclamation),
      label: FontUtils.secondColorText(
        '退会',
      ),
      onPressed: () async {
        _ConfirmDialog _confirmDialog = _ConfirmDialog(() async {
          await LeaveLogDBFirestore().leave(CommonConfig.mine!);
          // await AuthFirebase.userDelete(FirebaseAuth.instance.currentUser!);
        });

        final String? selectedText = await showDialog<String>(
            context: _context,
            builder: (_) {
              return _confirmDialog.userDelete();
            });
      });

  static TextButton _logoutButton = TextButton.icon(
      icon: Icon(Icons.logout),
      label: FontUtils.secondColorText(
        'ログアウト',
      ),
      onPressed: () {
        AuthFirebase.logout();
      });
}

class _InputPassword {
  static final RxBool _isTrRx = RxBool(false);
  static final RxBool _isShowRx = RxBool(false);
  static final RxBool _isupdateRx = RxBool(false);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _controller = TextEditingController();

  static _ConfirmDialog _confirmDialog = _ConfirmDialog(() async {
    bool result = await AuthFirebase.updatePassword(
        FirebaseAuth.instance.currentUser!,
        _confirmDialog.password,
        _controller.text);
    if (result) {
      CommonConfig.showSnackBar(MessageConfig.updatePassword.message);
      // AuthFirebase.logout();
    } else {
      CommonConfig.showSnackBar(AuthFirebase.endMessage);
    }
  });
  _InputPassword() {
    _isTrRx.value = false;
    _isShowRx.value = false;
    _isupdateRx.value = false;
    _controller.text = '';
  }

  Obx form = Obx(() => Form(
      key: _formKey,
      child: TextFormField(
        autovalidateMode: _isShowRx.value
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: _controller,
        validator: Validator.newPassword,
        keyboardType: TextInputType.visiblePassword,
        decoration: _inputDecorationPassword(),
        obscureText: !_isShowRx.value,
        onChanged: (value) {
          _isupdateRx.value = true;
        },
      )));

  static InputDecoration _inputDecorationPassword() {
    return InputDecoration(
        filled: true,
        hintText: '新しいパスワード',
        //TextFormFieldの右側にアイコンを表示
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                _isShowRx.value ? Icons.visibility : Icons.visibility_off,
                color: _theme.colorScheme.primary,
              ),
              onPressed: () {
                _isShowRx.value = !_isShowRx.value;
              },
            ),
            _isupdateRx.value
                ? IconButton(
                    onPressed: _updatePassword,
                    icon: Icon(
                      Icons.autorenew,
                      color: _theme.colorScheme.primary,
                      // color: CommonConfig.secondaryColor,
                    ),
                  )
                : Container()
          ],
        ));
  }

  static void _updatePassword() async {
    _isTrRx.value = true;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String? selectedText = await showDialog<String>(
        context: _context,
        builder: (_) {
          _confirmDialog.init();
          return _confirmDialog.passwordReInput();
        });
  }
}

class _InputEmail {
  static final RxBool _isTrRx = RxBool(false);
  static final RxBool _isupdateRx = RxBool(false);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _controller = TextEditingController();

  static _ConfirmDialog _confirmDialog = _ConfirmDialog(() async {
    bool result = await AuthFirebase.updateEmail(
        FirebaseAuth.instance.currentUser!,
        _controller.text,
        _confirmDialog.password);
    if (result) {
      CommonConfig.showSnackBar(MessageConfig.updateAccountSend.message);
      AuthFirebase.logout();
    } else {
      CommonConfig.showSnackBar(AuthFirebase.endMessage);
    }
  });

  _InputEmail() {
    _isTrRx.value = false;
    _isupdateRx.value = false;
    _controller.text = FirebaseAuth.instance.currentUser!.email!;
  }

  Obx form = Obx(() => Form(
      key: _formKey,
      child: TextFormField(
        // autofocus: true,
        autovalidateMode: _isTrRx.value
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: _controller,
        validator: Validator.accountEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecorationEmail(),
        onChanged: (value) {
          _isupdateRx.value = true;
        },
      )));

  static InputDecoration _inputDecorationEmail() {
    return InputDecoration(
        filled: true,
        hintText: 'メールアドレス',
        fillColor: Colors.transparent,
        suffixIcon: _isupdateRx.value
            ? IconButton(
                onPressed: _updateEmail,
                icon: Icon(
                  Icons.autorenew,
                  color: _theme.colorScheme.primary,
                  // color: CommonConfig.secondaryColor,
                ),
              )
            : null);
  }

  static void _updateEmail() async {
    _isTrRx.value = true;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String? selectedText = await showDialog<String>(
        context: _context,
        builder: (_) {
          _confirmDialog.init();
          return _confirmDialog.passwordReInput('メールアドレス更新後はログアウトします');
        });
  }
}

class _ConfirmDialog {
  String password = '';
  RxBool isShowRx = RxBool(false);
  RxBool isDeleteConfirm = RxBool(false);
  RxBool isDeleteConfirmErr = RxBool(false);
  Function _func;
  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _ConfirmDialog(this._func);

  init() {
    password = '';
    _controller.text = '';
    isShowRx.value = false;
  }

  SimpleDialog passwordReInput([String cationMsg = '']) {
    List<Widget> _cationMsg = cationMsg == ''
        ? []
        : [FontUtils.body1Err(cationMsg), SpaceUtils.smallY];
    return SimpleDialog(
      contentPadding: EdgeInsets.all(SpaceUtils.bigSpace),
      title: Center(child: FontUtils.body1Bold('現在のパスワードを入力')),
      children: [
        ..._cationMsg,
        ScaffoldUtils.maxCenterBox(Column(
          children: [
            Form(
              key: _formKey,
              child: Obx(() => TextFormField(
                    controller: _controller,
                    validator: Validator.required,
                    keyboardType: TextInputType.visiblePassword,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'パスワード',
                      //TextFormFieldの右側にアイコンを表示
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowRx.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          isShowRx.value = !isShowRx.value;
                        },
                      ),
                    ),
                    obscureText: !isShowRx.value,
                  )),
            ),
            SpaceUtils.bigY,
            ElevatedButton(
              style: ButtonUtils.buttonStyle,
              onPressed: () async {
                Function awaitEnd = FutureUtils.awaitStart();
                password = _controller.text;
                if (!_formKey.currentState!.validate()) {
                  awaitEnd();
                  return;
                }
                if (CommonConfig.mine!.testMode) {
                  CommonConfig.testSnackbar('変更機能');
                  awaitEnd();
                  Navigator.pop(_context, '閉じた');
                  return;
                }
                await _func();
                awaitEnd();
                Navigator.pop(_context, '閉じた');
              },
              child: FontUtils.body1Bold('更新'),
            )
          ],
        ))
      ],
    );
  }

  SimpleDialog userDelete() {
    isDeleteConfirm.value = false;
    isDeleteConfirmErr.value = false;
    return SimpleDialog(
      contentPadding: EdgeInsets.all(SpaceUtils.bigSpace),
      title: Center(child: FontUtils.body1Bold('退会前にご確認ください')),
      children: [
        Card(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: SpaceUtils.normalSpace,
                horizontal: SpaceUtils.smallSpace),
            child: Center(
                child: FontUtils.body1Err(
                    '退会すると、すべてのデータが削除されます。\n削除されたデータは元に戻せません。')),
          ),
        ),
        ScaffoldUtils.maxCenterBox(Column(
          children: [
            Obx(() => CheckboxListTile(
                  activeColor: Colors.red,
                  title: Align(
                      alignment: Alignment.centerLeft,
                      child: FontUtils.body1('すべてのデータが削除されることを確認しました')),
                  controlAffinity: ListTileControlAffinity.leading,
                  visualDensity: VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  value: isDeleteConfirm.value,
                  onChanged: (bool? value) {
                    isDeleteConfirm.value = !isDeleteConfirm.value;
                  },
                )),
            Obx(() => isDeleteConfirmErr.value
                ? FontUtils.body1Err('退会する前に、確認事項にチェックを付けてください')
                : Container()),
            SpaceUtils.normalY,
            ElevatedButton(
              style: ButtonUtils.buttonStyleErr,
              onPressed: () async {
                Function awaitEnd = FutureUtils.awaitStart();
                if (!isDeleteConfirm.value) {
                  isDeleteConfirmErr.value = true;
                  awaitEnd();
                  return;
                }

                if (CommonConfig.mine!.testMode) {
                  CommonConfig.testSnackbar('退会機能');
                  awaitEnd();
                  Navigator.pop(_context, '閉じた');
                  return;
                }
                try {
                  await _func();
                } catch (e) {
                  print(e);
                  CommonConfig.showSnackBar(MessageConfig.commonErr.message);
                }
                awaitEnd();

                Navigator.pop(_context, '閉じた');
              },
              child: FontUtils.body1Bold('退会'),
            ),
            SpaceUtils.bigY,
            ElevatedButton(
              style: ButtonUtils.buttonStyle,
              onPressed: () async {
                Navigator.pop(_context, '閉じた');
              },
              child: FontUtils.body1Bold('キャンセル'),
            )
          ],
        ))
      ],
    );
  }
}
