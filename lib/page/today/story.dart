import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favocchi/utils/font.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart' as intl;

import '../../config/common.dart';
import '../../config/routes.dart';
import '../../firebase/db/story.dart';
import '../../firebase/db/story_message.dart';
import '../../model/firabase_file.dart';
import '../../utils/button.dart';
import '../../utils/file_get.dart';
import '../../utils/file_saver.dart';
import '../../utils/future.dart';
import '../../utils/notifications.dart';
import '../../utils/scaffold.dart';
import '../../utils/space.dart';

String docId = '';
Map<String, String> messageMap = <String, String>{};

class StoryTodayPage extends StatefulWidget {
  const StoryTodayPage({Key? key}) : super(key: key);
  @override
  _StoryTodayPageState createState() => _StoryTodayPageState();
}

class _StoryTodayPageState extends State<StoryTodayPage> {
  static const int maxLength = 10000;
  static const int fetchCount = 60;
  static const double scrollDiff = 900;
  static const Map<String, double> sendFormHeight = {
    'minHeight': 58,
    'maxHeight': 78,
    'padding': SpaceUtils.smallHalfSpace
  };
  static final sendFormTotalHeight =
      sendFormHeight['maxHeight']! + (sendFormHeight['padding']! * 2);
  static final BuildContext _context = CommonConfig().mainContext;
  static String uid = FirebaseAuth.instance.currentUser!.uid;
  static String title = '';
  static bool sendButtonEnabled = true;
  static bool viewMode = false;
  static String sendingMessage = '';

  static RxDouble sendFormHeightRx = RxDouble(58);
  static GlobalKey messageAreaGlobalKey = GlobalKey();
  static FocusNode sendFormFocus = FocusNode();

  static int listCount = 0; // データ件数は上回らない
  static TextEditingController textController = TextEditingController();
  static late StoryMessageDBFirestore storyMessageDBFirestore;

  // static RxString backgroundRx = RxString('');
  static Rx<CachedNetworkImage?> backgroundRx = Rx<CachedNetworkImage?>(null);
  static RxInt listViewRx = RxInt(fetchCount);
  static RxBool scrollButtonRx = RxBool(false);
  static RxString writingMessageRx = RxString('');

  static ScrollController scrollController = ScrollController()
    ..addListener(() {
      double maxScrollY = scrollController.position.maxScrollExtent;
      double nowScrollY = scrollController.position.pixels;
      // print(nowScrollY);
      if (maxScrollY - scrollDiff <= nowScrollY) {
        listViewCountUp(fetchCount);
      }
      if (nowScrollY > 700) {
        scrollButtonRx.value = true;
      } else {
        scrollButtonRx.value = false;
      }
    });

  static listViewCountUp(int plus) {
    int _plus = listViewRx.value + plus < listCount
        ? listViewRx.value + plus
        : listCount;
    if (listViewRx.value != _plus) {
      listViewRx.value = _plus;
    }
  }

  static init() {
    // docId = 'hdm9W5BInWz939fo0kyE';
    // storyMessageDBFirestore = StoryMessageDBFirestore(docId, uid);
    // return;

    if (Get.arguments != null) {
      docId = Get.arguments['docId'];
      title = Get.arguments['title'];
      viewMode =
          Get.arguments.containsKey('viewMode') && Get.arguments['viewMode'];
      if (Get.arguments['lastImageUrl'] != null) {
        backgroundRx.value = Get.arguments['lastImageUrl'];
      } else {
        backgroundRx.value = null;
      }
      sendButtonEnabled = true;
      sendingMessage = '';
      listCount = 0;
      textController.text = messageMap[docId] ?? '';
      storyMessageDBFirestore = StoryMessageDBFirestore(docId, uid);
      listViewRx.value = fetchCount;
      scrollButtonRx.value = false;
      writingMessageRx.value = textController.text;
    } else {
      textController.text = '';
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        if (messageAreaGlobalKey.currentContext != null) {
          RenderBox box = messageAreaGlobalKey.currentContext!
              .findRenderObject()! as RenderBox;
          if (sendFormHeightRx.value != box.size.height) {
            sendFormHeightRx.value = box.size.height;
          }
        }
      } else {
        Future.delayed(Duration.zero, () {
          Get.offNamed(RoutesConfig.home.url);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    if (docId == '') {
      return Container();
    }

    storyMessageDBFirestore = StoryMessageDBFirestore(docId, uid);
    return ScaffoldUtils.storyPage(
        RoutesConfig.storyToday,
        Stack(
          // fit: StackFit.passthrough, //1
          children: [
            // Container(
            //   width: double.infinity,
            //   height: double.infinity,
            //   color: Colors.yellow,
            //   child: imageBackground(),
            // ),
            imageBackground(),
            maskBackground(),
            storyArea(context),
            // InkWell(
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return Text('ok');
            //         });
            //   },
            //   child: Text('ok'),
            // ),
            viewMode ? Container() : sendForm(context),
            Container()
          ],
        ),
        title,
        automaticallyImplyLeading: true,
        floatingActionButton: Obx(() => Container(
              margin: EdgeInsets.only(bottom: sendFormHeightRx.value),
              child: scrollButtonRx.value
                  ? ButtonUtils.circleGradientButton(
                      Icons.arrow_downward, scrollDown, 35, 3)
                  : Container(),
            )));
  }

  static imageShow(BuildContext context, CachedNetworkImage image) {
    Color color = Color(0xff364548);
    showDialog(
      barrierColor: color.withOpacity(0.9), //_theme.colorScheme.primary,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
              color: color,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: ((() {
                      Navigator.pop(context, '閉じた');
                    })),
                    icon: Icon(
                      Icons.close,
                      size: FontUtils.h4Size,
                      color: Colors.white,
                    )),
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Container(
                  alignment: Alignment.center,
                  // width: 800,
                  child: Stack(
                    children: [
                      InkWell(
                          mouseCursor: MouseCursor.defer,
                          onTap: (() {
                            Navigator.pop(context, '閉じた');
                          }),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                          )),
                      Center(child: image),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: SpaceUtils.smallSpace),
              color: color,
              child: kIsWeb
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: ((() async {
                            String url = image.imageUrl;
                            final httpsReference =
                                FirebaseStorage.instance.refFromURL(url);
                            String fileName = httpsReference.name;

                            Uint8List? fileData =
                                await httpsReference.getData();
                            FullMetadata meta =
                                await httpsReference.getMetadata();
                            String mimeType = meta.contentType ?? '';

                            String extension =
                                meta.contentType != 'image/svg+xml'
                                    ? (fileName.split('.').length == 2
                                        ? fileName.split('.')[1]
                                        : '')
                                    : 'svg';
                            if (fileName.split('.').length < 2 &&
                                extension == 'svg') {
                              fileName += '.svg';
                            }

                            try {
                              await FileSaver.instance.saveAs(
                                  fileName, fileData!, extension, mimeType);

                              NotificationsUtils.notifyNow('ダウンロード完了', null);
                            } catch (e) {
                              try {
                                await FileSaver.instance.saveFile(
                                    httpsReference.name, fileData!, extension,
                                    mime: mimeType);
                              } catch (e) {
                                CommonConfig.showSnackBar('ダウンロードできませんでした');
                              }
                            }
                          })),
                          icon: Icon(
                            Icons.download,
                            size: FontUtils.h4Size,
                            color: Colors.white,
                          )),
                    ),
            ),
          ],
        );
      },
    );
  }

  static Widget storyArea(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: storyMessageDBFirestore.snapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            listCount = snapshot.data!.docs.length;
            return snapshotBuilder(context, snapshot);
          }
          return Container(); //messageArea('', false);
        });
  }

  static void scrollDown() {
    double nowScrollY = scrollController.position.pixels;
    nowScrollY > 1500
        ? scrollController.jumpTo(0)
        : scrollController.animateTo(
            nowScrollY > 50 ? -10 : 0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          );
  }

  static Widget sendForm(BuildContext context) {
    bool shiftDown = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          key: messageAreaGlobalKey,
          color: Colors.white.withOpacity(0.5),
          child: Padding(
            padding: EdgeInsets.all(sendFormHeight['padding']!),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kIsWeb == false
                    ? ButtonUtils.defaultCircleButton(Icons.photo_camera,
                        sendFormHeight['minHeight']! - SpaceUtils.bigSpace,
                        () async {
                        String path =
                            await FileGetUtils.storyMessagePhoto(uid, docId);
                        if (path.length > 0) {
                          backgroundUpdate(path);
                          listViewCountUp(1);
                          scrollDown();
                        }
                      })
                    : Container(),
                ButtonUtils.defaultCircleButton(Icons.photo,
                    sendFormHeight['minHeight']! - SpaceUtils.bigSpace,
                    () async {
                  List<String> list =
                      await FileGetUtils.storyMessageMultiImage(uid, docId);
                  if (list.length > 0) {
                    backgroundUpdate(list[list.length - 1]);
                    listViewCountUp(list.length);
                    scrollDown();
                  }
                }),
                SpaceUtils.smallX,
                Flexible(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: CommonConfig.defaultFormMaxWidth,
                        minHeight: sendFormHeight['minHeight']!,
                        maxHeight: sendFormHeight['maxHeight']!,
                      ),
                      child: Focus(
                        onKey: (FocusNode node, RawKeyEvent event) {
                          bool shiftKey =
                              event.logicalKey == LogicalKeyboardKey.shift ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.shiftLeft ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.shiftRight ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.shiftLevel5;
                          bool enterKey =
                              event.logicalKey == LogicalKeyboardKey.enter ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.numpadEnter;

                          if (event is RawKeyDownEvent) {
                            if (shiftKey) shiftDown = true;
                            if (shiftDown && enterKey) {
                              sendButtonEnabled ? sendMessageAction() : null;
                              return KeyEventResult.handled;
                            }
                          } else if (event is RawKeyUpEvent) {
                            if (shiftKey) {
                              shiftDown = false;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        child: Center(
                          heightFactor: 1,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            focusNode: sendFormFocus,
                            autofocus: true,
                            controller: textController,
                            onChanged: (value) {
                              if (value.length > maxLength) {
                                int offset =
                                    textController.selection.baseOffset;
                                textController.text =
                                    value.substring(0, maxLength);
                                offset = offset > textController.text.length
                                    ? textController.text.length
                                    : offset;
                                textController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: offset));
                              }
                              writingMessageRx.value = value;
                              messageMap[docId] = value;
                              WidgetsBinding.instance
                                  .addPostFrameCallback((cb) {
                                RenderBox box = messageAreaGlobalKey
                                    .currentContext!
                                    .findRenderObject()! as RenderBox;
                                if (sendFormHeightRx.value != box.size.height) {
                                  sendFormHeightRx.value = box.size.height;
                                }
                              });
                            },
                            decoration: InputDecoration(
                                // isDense: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder()),
                            // onSubmitted: sendMessageAction,
                          ),
                        ),
                      )),
                ),
                SpaceUtils.smallHalfSpaceX,
                Obx(() => ButtonUtils.defaultCircleButton(
                    Icons.send,
                    sendFormHeight['minHeight']! - SpaceUtils.bigSpace,
                    sendMessageAction,
                    isEnabled: sendButtonEnabled &&
                        (writingMessageRx.value).trim().length != 0)),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).padding.bottom,
        ),
      ],
    );
  }

  static void sendMessageAction([String value = '']) async {
    sendButtonEnabled = false;
    messageMap[docId] = '';
    scrollDown();
    sendingMessage = textController.text;
    if (sendingMessage.trim().length == 0) {
      sendButtonEnabled = true;
      return;
    }
    textController.text = '';
    writingMessageRx.value = '';
    sendFormFocus.requestFocus();
    await StoryMessageDBFirestore.sendMessage(uid, message: sendingMessage);
    sendingMessage = '';
    sendButtonEnabled = true;
    listViewCountUp(1);
  }

  static Widget snapshotBuilder(context, snapshot) {
    print('snapshot');
    return Obx(() => Container(
          padding: EdgeInsets.only(
              right: SpaceUtils.normalSpace,
              left: SpaceUtils.normalSpace,
              bottom: (viewMode ? 0 : sendFormHeightRx.value) +
                  // SpaceUtils.smallSpace +
                  MediaQuery.of(context).padding.bottom),
          child: () {
            print('listObx');
            List<Widget> listView = [];
            int itemCount = listViewRx.value < listCount
                ? listViewRx.value
                : listCount; // listCountを上回らないか再チェック
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            for (int index = 0; index < itemCount; index++) {
              final doc = snapshot.data!.docs[index];
              // String docID = doc.id;
              final Map<String, dynamic> data =
                  doc.data()! as Map<String, dynamic>;

              final oldData = index + 1 < snapshot.data!.docs.length
                  ? snapshot.data!.docs[index + 1].data()!
                      as Map<String, dynamic>
                  : null;
              DateTime? oldDate = oldData == null
                  ? null
                  : StoryMessageDBFirestore.getTime(oldData).toDate();
              ;
              DateTime thisDate =
                  StoryMessageDBFirestore.getTime(data).toDate();
              bool showDay = oldDate == null ||
                  (oldDate != null &&
                      intl.DateFormat('yyyyMMdd').format(oldDate) !=
                          intl.DateFormat('yyyyMMdd').format(thisDate));
              listView.insert(
                  0,
                  Column(children: [
                    showDay
                        ? Container(
                            padding: EdgeInsets.only(
                                top: SpaceUtils.normalSpace,
                                bottom: SpaceUtils.smallSpace),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                  colors: [
                                    const Color(0xffe4a972).withOpacity(0.8),
                                    const Color(0xff9941d8).withOpacity(0.8),
                                  ],
                                  stops: const [
                                    0.0,
                                    1.0,
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: SpaceUtils.smallQuarterSpace,
                                  horizontal: SpaceUtils.bigSpace),
                              child: Center(
                                  widthFactor: 1,
                                  child: FontUtils.body1White(
                                      intl.DateFormat('yyyy/MM/dd')
                                              .format(thisDate) +
                                          'の活動')),
                            ),
                          )
                        : Container(),
                    messageArea(context, data),
                  ]));
            }
            return SingleChildScrollView(
                reverse: true,
                controller: scrollController,
                child: Column(children: listView));
          }(),
          // child: ListView.builder(
          //     cacheExtent: 10000,
          //     controller: scrollController,
          //     physics: RangeMaintainingScrollPhysics(),
          //     shrinkWrap: true,
          //     reverse: true,
          //     itemCount: listViewRx.value < listCount
          //         ? listViewRx.value
          //         : listCount, //snapshot.data!.docs.length,
          //     itemBuilder: (context, index) {
          //       print('ListView');
          //       final doc = snapshot.data!.docs[index];
          //       // String docID = doc.id;
          //       final Map<String, dynamic> data =
          //           doc.data()! as Map<String, dynamic>;
          //       final oldData = index + 1 < snapshot.data!.docs.length
          //           ? snapshot.data!.docs[index + 1].data()!
          //               as Map<String, dynamic>
          //           : null;
          //       DateTime? oldDate = oldData == null
          //           ? null
          //           : StoryMessageDBFirestore.getTime(oldData).toDate();
          //       ;
          //       DateTime thisDate =
          //           StoryMessageDBFirestore.getTime(data).toDate();
          //       bool showDay = oldDate == null ||
          //           (oldDate != null &&
          //               intl.DateFormat('yyyyMMdd').format(oldDate) !=
          //                   intl.DateFormat('yyyyMMdd').format(thisDate));
          //       return Column(
          //         children: [
          //           showDay
          //               ? Container(
          //                   padding: EdgeInsets.only(
          //                       top: SpaceUtils.normalSpace,
          //                       bottom: SpaceUtils.smallSpace),
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(3),
          //                       gradient: LinearGradient(
          //                         begin: FractionalOffset.topLeft,
          //                         end: FractionalOffset.bottomRight,
          //                         colors: [
          //                           const Color(0xffe4a972).withOpacity(0.5),
          //                           const Color(0xff9941d8).withOpacity(0.3),
          //                         ],
          //                         stops: const [
          //                           0.0,
          //                           1.0,
          //                         ],
          //                       ),
          //                     ),
          //                     padding: EdgeInsets.symmetric(
          //                         vertical: SpaceUtils.smallQuarterSpace,
          //                         horizontal: SpaceUtils.bigSpace),
          //                     child: Center(
          //                         widthFactor: 1,
          //                         child: FontUtils.body1White(
          //                             intl.DateFormat('yyyy/MM/dd')
          //                                     .format(thisDate) +
          //                                 'の活動')),
          //                   ),
          //                 )
          //               : Container(),
          //           messageArea(context, data),
          //         ],
          //       );
          //     }),
        ));
  }

  static Widget messageArea(BuildContext context, dynamic data) {
    double minHeight = 160;
    double maxHeight = (MediaQuery.of(context).size.height -
            (SpaceUtils.bigSpace * 2) -
            AppBar().preferredSize.height -
            sendFormHeight['maxHeight']!) /
        3;
    bool isBackColor = true;
    Widget widget = Container();
    Type type = StoryMessageDBFirestore.getType(data);
    bool fullscreen = type == CachedNetworkImage;
    if (type == String) {
      String? message = StoryMessageDBFirestore.getMessage(data);
      widget = SelectionArea(child: FontUtils.body1(message ?? ''));
    } else if (type == CachedNetworkImage) {
      isBackColor = false;
      String? url = StoryMessageDBFirestore.getUrl(data);
      Widget errWidget = Container(
        padding: EdgeInsets.symmetric(horizontal: SpaceUtils.smallQuarterSpace),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SpaceUtils.smallX,
            FontUtils.body1('画像が読み込めませんでした'),
          ],
        ),
      );
      BoxConstraints constraints = BoxConstraints(
        maxWidth: CommonConfig.defaultFormMaxWidth,
        maxHeight: maxHeight < minHeight ? minHeight : maxHeight,
        minHeight: minHeight,
        // (MediaQuery.of(context).size.height -
        //         (SpaceUtils.bigSpace * 2) -
        //         AppBar().preferredSize.height -
        //         sendFormHeight['maxHeight']!) /
        //     3
      );
// backgroundRx.value
      CachedNetworkImage image = CachedNetworkImage(
        imageUrl:
            // 'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?fit=bounds&format=jpeg&quality=85&width=330',
            url ?? '',
        placeholder: (context, url) => Stack(
          children: [
            Center(
              child:
                  ConstrainedBox(constraints: constraints, child: Container()),
            ),
            Center(child: CircularProgressIndicator())
          ],
        ),
        errorWidget: (context, url, dynamic error) {
          // backgroundRx.value = lastImageListDocShowPrev;
          return errWidget;
        },
        // imageBuilder: (context, imageProvider) {
        // },
      );
      widget = ConstrainedBox(
          constraints: constraints,
          child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                imageShow(context, image);

                // // バグ回避
                // Future.delayed(Duration(milliseconds: 300)).then((_) {
                //   imageShow(context, image);
                // });
              },
              child: image));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
                top: SpaceUtils.smallQuarterSpace,
                bottom: SpaceUtils.smallQuarterSpace),
            padding: EdgeInsets.symmetric(
                horizontal: SpaceUtils.smallSpace,
                vertical: SpaceUtils.smallHalfSpace),
            child: widget,
            decoration: BoxDecoration(
              color: isBackColor
                  ? CupertinoTheme.of(_context)
                      .barBackgroundColor
                      .withOpacity(0.8)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  static Widget imageBackground() {
    return Obx(() => Container(
          width: double.infinity,
          height: double.infinity,
          child: backgroundRx.value,
        ));
  }

  static backgroundUpdate(String path) {
    CachedNetworkImage image = CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: path,
      errorWidget: (context, url, dynamic error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          backgroundRx.value = null;
        });
        return Container();
      },
    );
    backgroundRx.value = image;
  }

  static Widget maskBackground() {
    return Obx(() => Container(
            decoration: BoxDecoration(
          color:
              backgroundRx.value == null ? null : Colors.grey.withOpacity(0.8),
          gradient: backgroundRx.value == null
              ? LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    const Color(0xffe4a972).withOpacity(0.1),
                    const Color(0xff9941d8).withOpacity(0.3),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ],
                )
              : null,
        )));
  }
}
