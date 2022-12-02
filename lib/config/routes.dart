import 'package:favocchi/page/account/password.dart';
import 'package:favocchi/page/home.dart';
import 'package:favocchi/page/other.dart';
import 'package:favocchi/page/today/create.dart';
import 'package:favocchi/page/today/story.dart';
import 'package:favocchi/page/today/top.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../model/page.dart';
import '../page/account/create.dart';
import '../page/account/login.dart';
import '../page/account/mailSend.dart';
import '../page/hi/top.dart';
import '../page/test.dart';

class RoutesConfig {
  // Home
  static PageModel home = PageModel(
      url: '/', title: 'トップページ', icon: Icons.home, widget: const HomePage());
  // account
  static PageModel createAccount = PageModel(
      url: '/new_account',
      title: 'ユーザー登録',
      icon: Icons.person_add,
      widget: const CreateAccountPage());
  static PageModel loginAccount = PageModel(
      url: '/login_account',
      title: 'ログイン',
      icon: Icons.login,
      widget: const LoginAccountPage());
  static PageModel passwordAccount = PageModel(
      url: '/password_account',
      title: 'パスワード再発行',
      icon: Icons.password,
      widget: const PasswordAccountPage());
  static PageModel mailSendAccount = PageModel(
      url: '/mail_send',
      title: 'メール送信完了',
      icon: Icons.mail,
      widget: const MailSendAccountPage());
  // todayPage
  static PageModel topToday = PageModel(
      url: '/top_today',
      title: 'today',
      icon: Icons.message,
      widget: const TopTodayPage());
  static PageModel createToday = PageModel(
      url: '/create_today',
      title: 'today',
      icon: Icons.message,
      widget: const CreateTodayPage());
  static PageModel storyToday = PageModel(
    url: '/story_today',
    title: 'today',
    icon: Icons.message,
    widget: const StoryTodayPage(),
    // middlewares: [StoryTodayArguments()]
  );
  // hi
  static PageModel topHi = PageModel(
      url: '/top_hi',
      title: 'hi',
      icon: FontAwesomeIcons.peopleRobbery,
      // autoFocus: true,
      widget: const TopHiPage());
  // otherPage
  static PageModel other = PageModel(
      url: '/other',
      title: 'その他',
      icon: Icons.more_vert,
      autoFocus: true,
      widget: const OtherPage());
  static PageModel test = PageModel(
      url: '/test',
      title: 'test',
      icon: Icons.more_vert,
      autoFocus: true,
      widget: const TestPage());

  static List<GetPage> getPages = () {
    List<PageModel> pages = [
      test,
      home,
      createAccount,
      loginAccount,
      mailSendAccount,
      topToday,
      createToday,
      storyToday,
      passwordAccount,
      topHi,
      other
    ];
    List<GetPage> getPages = [];
    for (PageModel page in pages) {
      getPages.add(GetPage(
        name: page.url,
        title: page.title,
        page: () => page.widget,
        middlewares: page.middlewares ?? [],
      ));
    }
    return getPages;
  }();
}

class StoryTodayArguments extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.arguments == null) {
      return RouteSettings(name: RoutesConfig.topToday.url);
      // Get.toNamed(RoutesConfig.topToday.url);
      // print('notNull');
      // return const RouteSettings(name: '/home');
    }
  }
}
