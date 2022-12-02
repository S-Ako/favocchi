import 'package:favocchi/utils/font.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../../utils/space.dart';
import 'package:flutter/material.dart';
import '../config/common.dart';
import '../config/routes.dart';
import '../model/bottom_navi.dart';
import '../model/page.dart';

class ScaffoldUtils {
  static final titleIconSize = FontUtils.h5Size;
  static final ThemeData _theme = Theme.of(CommonConfig().mainContext);
  static final IconThemeData _iconTheme = _theme.iconTheme;
  static Widget maxCenterBox(Widget body,
      {double maxWidth = CommonConfig.defaultContentMaxWidth}) {
    return Center(
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: body),
    );
  }

  static Scaffold appTitlePage(PageModel page, Widget body,
      {bool setting = false}) {
    IconData? titleIcon = null;
    //page.icon;
    // タイトル横にアイコンを表示するか
    List<Widget> title = titleIcon == null
        ? [SizedBox(width: titleIconSize), FontUtils.bodyTitle(page.title)]
        : [
            SizedBox(width: titleIconSize),
            Icon(
              titleIcon,
              size: titleIconSize,
              // color: CommonConfig.secondaryColor,
            ),
            SpaceUtils.smallX,
            FontUtils.bodyTitle(page.title),
            SpaceUtils.smallX,
            SizedBox(width: titleIconSize)
          ];
    List<Widget> appBar = [
      Container(
        width: titleIconSize! * 1.3,
        height: titleIconSize! * 1.3,
        child: FittedBox(
            fit: BoxFit.contain, child: Image.asset(CommonConfig.appIconPath)),
      ),
      // CircleAvatar(
      //     radius: titleIconSize,
      //     child: Padding(
      //         padding: EdgeInsets.all(SpaceUtils.smallHalfSpace),
      //         child: Image.asset(CommonConfig.appIconPath))),
      SpaceUtils.smallX,
      FontUtils.bodyTitle(CommonConfig.title),
      SpaceUtils.smallX,
      // SizedBox(width: titleIconSize)
    ];
    return defaultPage(
      page,
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: title),
          SpaceUtils.bigY,
          body
        ],
      ),
      appBarTitle: appBar,
      setting: setting,
    );
  }

  static Scaffold defaultPage(
    PageModel page,
    Widget body, {
    bool setting = false,
    List<Widget>? appBarTitle,
    Widget? floatingActionButton,
    automaticallyImplyLeading = false,
    EdgeInsets? padding,
    bool selfScrollControl = false,
  }) {
    IconData? titleIcon = page.icon;
    padding ??= EdgeInsets.all(SpaceUtils.normalSpace);
    // appBarのタイトル横にアイコンを表示するか
    List<Widget> title = appBarTitle ??
        ((titleIcon == null)
            ? [SizedBox(width: titleIconSize), FontUtils.bodyTitle(page.title)]
            : [
                SizedBox(width: titleIconSize),
                Icon(
                  titleIcon,
                  size: titleIconSize,
                  color: _theme.colorScheme.primary,
                ),
                SpaceUtils.smallX,
                FontUtils.bodyTitle(page.title),
                SpaceUtils.smallX,
                SizedBox(width: titleIconSize),
                automaticallyImplyLeading ? SizedBox(width: 55) : Container()
              ]);
    // 設定ボタンを表示するかどうか
    List<Widget> settingIcon = setting
        ? [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: titleIconSize,
              ),
              onPressed: () => {},
            ),
          ]
        : [];

    return Scaffold(
        appBar: NewGradientAppBar(
            // backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            automaticallyImplyLeading: automaticallyImplyLeading,
            actions: settingIcon,
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: title,
            )),
        body: selfScrollControl
            ? Container(
                // reverse: true,
                padding: padding,
                child: Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: CommonConfig.defaultContentMaxWidth,
                      ),
                      child: body),
                ))
            : SingleChildScrollView(
                // reverse: true,
                padding: padding,
                child: Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: CommonConfig.defaultContentMaxWidth,
                      ),
                      child: body),
                )),
        floatingActionButton: floatingActionButton);
  }

  static Scaffold storyPage(PageModel page, Widget body, String _title,
      {bool setting = false,
      Widget? floatingActionButton,
      automaticallyImplyLeading = false,
      EdgeInsets? padding}) {
    padding ??= EdgeInsets.all(SpaceUtils.normalSpace);
    List<Widget> title = [FontUtils.bodyTitle(_title), SizedBox(width: 55)];
    // 設定ボタンを表示するかどうか
    List<Widget> settingIcon = setting
        ? [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: titleIconSize,
              ),
              onPressed: () => {},
            ),
          ]
        : [];

    return Scaffold(
        appBar: NewGradientAppBar(
            // backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            automaticallyImplyLeading: automaticallyImplyLeading,
            actions: settingIcon,
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
            ),
            title: Center(
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: title,
                  )),
            )),
        body: Center(child: body),
        // body: Stack(children: [
        //   // Image.asset('assets/images/flower4.png'),
        //   Center(child: body
        //       // ConstrainedBox(
        //       //     constraints: BoxConstraints(
        //       //       maxWidth: CommonConfig.defaultContentMaxWidth,
        //       //     ),
        //       //     child: body /*Padding(padding: padding, child: body)*/),
        //       ),
        // ]),
        floatingActionButton: floatingActionButton);
  }

  static Scaffold backgroundInfinityPage(PageModel page, Widget body,
      {bool setting = false,
      List<Widget>? appBarTitle,
      Widget? floatingActionButton,
      automaticallyImplyLeading = false}) {
    IconData? titleIcon = page.icon;
    // appBarのタイトル横にアイコンを表示するか
    List<Widget> title = appBarTitle ??
        ((titleIcon == null)
            ? [SizedBox(width: titleIconSize), FontUtils.bodyTitle(page.title)]
            : [
                SizedBox(width: titleIconSize),
                Icon(
                  titleIcon,
                  size: titleIconSize,
                  color: _theme.colorScheme.primary,
                ),
                SpaceUtils.smallX,
                FontUtils.bodyTitle(page.title),
                SpaceUtils.smallX,
                SizedBox(width: titleIconSize),
                automaticallyImplyLeading ? SizedBox(width: 55) : Container()
              ]);
    // 設定ボタンを表示するかどうか
    List<Widget> settingIcon = setting
        ? [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: titleIconSize,
              ),
              onPressed: () => {},
            ),
          ]
        : [];

    return Scaffold(
        appBar: NewGradientAppBar(
            // backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            automaticallyImplyLeading: automaticallyImplyLeading,
            actions: settingIcon,
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: title,
            )),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(SpaceUtils.normalSpace),
            child: Center(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: CommonConfig.defaultContentMaxWidth,
                  ),
                  child: body),
            )),
        floatingActionButton: floatingActionButton);
  }

  static Scaffold bottomNaviPage(
      PageModel page, List<BottomNaviModel> naviList, RxInt tabObs) {
    // ナビデータ
    List<BottomNavigationBarItem> bottomNavigationBarItemList = () {
      List<BottomNavigationBarItem> list = [];
      for (BottomNaviModel naviData in naviList) {
        list.add(BottomNavigationBarItem(
          icon: naviData.icon,
          label: naviData.tabName,
        ));
      }
      return list;
    }();
    // 横スワイプ用
    final PageController pageController = PageController();
    // 横スワイプの中身
    final List<Widget> swipePageList =
        naviList.map((naviData) => naviData.page.widget).toList();
    // ページ切り替え
    void onBottomNavigationBarTap(int index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: swipePageList,
        onPageChanged: (index) {
          if (!naviList[index].page.autoFocus) primaryFocus?.unfocus();
          tabObs.value = index;
        },
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: _theme.colorScheme.primary),
            selectedItemColor: Colors.black54,
            currentIndex: tabObs.value,
            type: BottomNavigationBarType.fixed,
            onTap: onBottomNavigationBarTap,
            items: bottomNavigationBarItemList,
          )),
    );
  }
}
