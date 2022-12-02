import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:favocchi/utils/button.dart';
import 'package:favocchi/utils/card.dart';
import '../../config/common.dart';
import '../../config/routes.dart';
import '../../firebase/db/story.dart';
import '../../page/account/common.dart';
import '../../utils/font.dart';
import '../../utils/scaffold.dart';
import '../../utils/space.dart';

late BuildContext _context;
final ThemeData _theme = Theme.of(CommonConfig().mainContext);
late Stream<List<Map<String, dynamic>?>> stream;

class TopTodayPage extends StatefulWidget {
  const TopTodayPage({Key? key}) : super(key: key);
  @override
  State<TopTodayPage> createState() => _TopTodayPage();
}

class _TopTodayPage extends State<TopTodayPage> {
  static final CommonAcountPage _commonAcountPage = CommonAcountPage();
  static Stream<QuerySnapshot> stream =
      StoryDBFirestore.getStoryList(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonConfig.mine;
    _context = context;
    List<Widget> widgetList = [];
    return ScaffoldUtils.defaultPage(
        RoutesConfig.topToday,
        StreamBuilder<QuerySnapshot>(
            stream: StoryDBFirestore.getStoryList(
                FirebaseAuth.instance.currentUser!.uid), //stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widgetList = [];
                if (snapshot.data!.docChanges.length != 2) {}
                for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String title = StoryDBFirestore.getTitle(data);
                  String? url = StoryDBFirestore.getLastImageUrl(data);
                  CachedNetworkImage? image =
                      url == null ? null : StoryDBFirestore.getLastImage(url);

                  widgetList.add(CardUtils.create(() {
                    Get.toNamed(RoutesConfig.storyToday.url, arguments: {
                      'docId': doc.id,
                      'title': title,
                      'lastImageUrl': image,
                    });
                  }, StoryDBFirestore.getTitle(data),
                      StoryDBFirestore.getUpdateTime(data).toDate(),
                      image: url == null
                          ? Image.asset(CommonConfig.appIconPath)
                          : image));
                }
              }
              return CommonConfig.mine!.storyList.length != 0
                  ? Wrap(
                      children: widgetList,
                    )
                  : Column(
                      children: [
                        SpaceUtils.normalY,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: FontUtils.h5Size,
                              height: FontUtils.h5Size,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(CommonConfig.appIconPath),
                                fit: BoxFit.contain,
                              )),
                            ),
                            SpaceUtils.smallX,
                            FontUtils.body1Bold(
                                '${CommonConfig.mine!.name}さん、ようこそfavochへ！'),
                          ],
                        ),
                        SpaceUtils.bigY,
                        FontUtils.body1('favochは匿名で趣味活動を発信できる場所です'),
                        SpaceUtils.bigY,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FontUtils.body1('右下の'),
                            ButtonUtils.circleGradientButton(
                                Icons.edit_note,
                                null,
                                FontUtils.h5Size!,
                                FontUtils.h5Size! / 10),
                            FontUtils.body1('ボタンから'),
                          ],
                        ),
                        FontUtils.body1('あなたの趣味を気軽に発信してください'),
                      ],
                    );
            }),
        floatingActionButton:
            ButtonUtils.circleGradientButton(Icons.edit_note, () {
          Get.toNamed(RoutesConfig.createToday.url);
        }));
  }
}
