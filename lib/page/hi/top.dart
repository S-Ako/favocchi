import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favocchi/config/common.dart';
import 'package:favocchi/config/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:favocchi/utils/button.dart';
import '../../../config/routes.dart';
import '../../../utils/scaffold.dart';
import '../../firebase/auth.dart';
import '../../firebase/db/story.dart';
import '../../utils/card.dart';
import '../../utils/future.dart';
import '../../utils/font.dart';
import '../../utils/space.dart';
import '../../validator/validator.dart';
import 'package:intl/intl.dart' as intl;

import 'dart:collection';

final ThemeData _theme = Theme.of(CommonConfig().mainContext);

class TopHiPage extends StatefulWidget {
  const TopHiPage({Key? key}) : super(key: key);
  @override
  State<TopHiPage> createState() => _TopHiPage();
}

class _TopHiPage extends State<TopHiPage> {
  final int bordNum = 9;
  static GlobalKey circleGradientButtonGlobalKey = GlobalKey();
  static RxDouble bottomSpaceRx = RxDouble(89);
  static RxBool _isIndoor = RxBool(true);
  static RxBool _isAlone = RxBool(true);
  static RxBool _isMinor = RxBool(true);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox box = circleGradientButtonGlobalKey.currentContext!
          .findRenderObject()! as RenderBox;
      RenderBox box2 = formKey.currentContext!.findRenderObject()! as RenderBox;
      double bottomHeight = box.size.height + box2.size.height;
      if (bottomSpaceRx.value != bottomHeight) {
        bottomSpaceRx.value = bottomHeight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> topWidget = [
      SpaceUtils.normalY,
      Align(
          alignment: Alignment.center, child: FontUtils.body1('みんなの一日を見てみよう')),
      SpaceUtils.bigY,
    ];
    return ScaffoldUtils.defaultPage(
        RoutesConfig.topHi,
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => FutureBuilder(
                      future: StoryDBFirestore.getStoryListRandomSearch(
                          _isIndoor.value,
                          _isAlone.value,
                          _isMinor.value,
                          bordNum * 3),
                      builder: (context, snapshot) {
                        List<Widget> widgetList = [];
                        Map<String, Widget> widgetMap = {};
                        // 通信中はスピナーを表示
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Column(
                            children: [
                              ...topWidget,
                              SpaceUtils.bigY,
                              const Center(child: CircularProgressIndicator()),
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          widgetList = [];
                          widgetMap = {};
                          if (snapshot.data!.docChanges.length != 2) {}
                          int count = 0;
                          for (QueryDocumentSnapshot doc
                              in snapshot.data!.docs) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            String createUser =
                                StoryDBFirestore.getCreateUser(data);
                            if (createUser ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              continue;
                            }
                            count++;

                            DateTime updateDate =
                                StoryDBFirestore.getUpdateTime(data).toDate();
                            String key = intl.DateFormat('yyyyMMddHHmmss')
                                    .format(updateDate) +
                                count.toString();
                            print(key);
                            String title = StoryDBFirestore.getTitle(data);
                            String? url =
                                StoryDBFirestore.getLastImageUrl(data);
                            CachedNetworkImage? image = url == null
                                ? null
                                : StoryDBFirestore.getLastImage(url);

                            widgetMap[key] = (CardUtils.create(() {
                              Get.toNamed(RoutesConfig.storyToday.url,
                                  arguments: {
                                    'docId': doc.id,
                                    'title': title,
                                    'lastImageUrl': image,
                                    'viewMode': true
                                  });
                            }, StoryDBFirestore.getTitle(data), updateDate,
                                image: url == null
                                    ? Image.asset(CommonConfig.appIconPath)
                                    : image));
                          }
                          widgetMap = SplayTreeMap.from(
                              widgetMap, (v1, v2) => v2.compareTo(v1));
                          widgetList =
                              widgetMap.entries.map((e) => e.value).toList();
                          widgetList = widgetList.toList()..shuffle();
                          if (widgetMap.length > bordNum) {
                            widgetList = widgetList.sublist(0, bordNum);
                          }

                          bordNum < widgetList.length;
                        }
                        return Column(
                          children: [
                            ...topWidget,
                            Wrap(
                              children: widgetList,
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ),
            Obx(() => SizedBox(height: bottomSpaceRx.value)),
          ],
        ),
        // '',
        padding: EdgeInsets.only(
            top: 0,
            right: SpaceUtils.normalSpace,
            bottom: SpaceUtils.normalSpace,
            left: SpaceUtils.normalSpace),
        selfScrollControl: true,
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Form(
                key: formKey,
                child: ScaffoldUtils.maxCenterBox(
                  Wrap(children: [
                    ButtonUtils.toggleRow(
                        _isIndoor, null, 'インドア', null, 'アウトドア',
                        isSmall: !kIsWeb, maxWidth: kIsWeb ? 170 : 120),
                    ButtonUtils.toggleRow(_isAlone, null, '単独OK', null, '2人以上',
                        isSmall: !kIsWeb, maxWidth: kIsWeb ? 170 : 100),
                    ButtonUtils.toggleRow(
                        _isMinor, null, '小学生OK', null, '年齢制限あり',
                        isSmall: !kIsWeb, maxWidth: kIsWeb ? 170 : 125),
                  ]),
                  // maxWidth: CommonConfig.toggleFormMinWidth
                )),
            Container(
              key: circleGradientButtonGlobalKey,
              child: ButtonUtils.circleGradientButton(
                  FontAwesomeIcons.rotateRight, () {
                setState(() {});
              }),
            ),
          ],
        ));
  }
}
