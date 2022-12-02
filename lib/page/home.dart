import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../config/common.dart';
import '../config/routes.dart';
import '../model/bottom_navi.dart';
import '../../utils/scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!CommonConfig.mine!.paid) {
        CommonConfig.defaultSnackbar(
            '無料版のため一部機能が制限されています', '有料版の公開まで、ぜひお楽しみください');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldUtils.bottomNaviPage(
        RoutesConfig.home,
        [
          BottomNaviModel(
              // page: RoutesConfig.topHi,
              page: RoutesConfig.topToday,
              icon: const Icon(Icons.message),
              tabName: 'Today'),
          BottomNaviModel(
              // page: RoutesConfig.topToday,
              page: RoutesConfig.topHi,
              icon: Icon(FontAwesomeIcons.peopleRobbery),
              tabName: 'Hi'),
          BottomNaviModel(
              page: RoutesConfig.other,
              icon: const Icon(Icons.more_vert),
              tabName: 'Other'),
        ],
        _HomePageConfig.tabIndexRx);
  }
}

class _HomePageConfig {
  // タブインデックス
  static final RxInt tabIndexRx = RxInt(0);
}
