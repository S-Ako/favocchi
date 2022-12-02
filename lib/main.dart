import 'package:favocchi/utils/future.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:favocchi/config/routes.dart';
import 'package:favocchi/page/account/login.dart';
import 'package:favocchi/page/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'config/originalTheme.dart';
import 'config/common.dart';
import 'firebase/db/user.dart';
import 'firebase/init.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  WidgetsFlutterBinding.ensureInitialized();
  // (通知スケジュールに使う)タイムゾーンを設定する
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));

  // flutter_local_notificationsの初期化
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CommonConfig().mainContext = context;
    return GetMaterialApp(
      builder: EasyLoading.init(),
      scaffoldMessengerKey: CommonConfig.scaffoldKey,
      title: CommonConfig.title, // webだとタブに表示される
      theme: OriginalTheme.blue,
      //     ThemeData(
      //   primarySwatch: Colors.blue, //CommonConfig.primaryColor,
      //   fontFamily: 'ZenKakuGothicAntique',
      // ),
      initialRoute: '/',
      getPages: RoutesConfig.getPages,
      // locale: Locale('ja', 'JP'),
      home: FutureBuilder<bool>(
          future: InitFirebase.connection(), // 遅延処理
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            // 通信中はスピナーを表示
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            // エラー発生時はエラーメッセージを表示
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // データがnullでないかチェック
            if (snapshot.hasData) {
              return loggedStream();
            } else {
              return Text("データが存在しません");
            }
          }),
    );
  }

  static StreamBuilder<User?> loggedStream() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && FirebaseAuth.instance.currentUser != null) {
          CommonConfig.mine =
              UserDBFirestore(FirebaseAuth.instance.currentUser!.uid);

          return FutureBuilder(
            future: CommonConfig.mine!.init(),
            builder: (context, future) {
              // 通信中はスピナーを表示
              if (future.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.emailVerified || CommonConfig.mine!.testMode) {
                // print(future.connectionState);
                FlutterNativeSplash.remove();
                return const HomePage();
              } else {
                FlutterNativeSplash.remove();
                return const LoginAccountPage();
              }
            },
            // snapshot.data!.updateDisplayName("Jane Q. User");
            // print(snapshot.data!.displayName);
          );
        }
        FlutterNativeSplash.remove();
        return const LoginAccountPage();
      },
    );
  }
}
