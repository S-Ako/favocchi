import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favocchi/config/common.dart';
import 'package:favocchi/firebase/db/config.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';

import '../storage/story_message.dart';

class StoryDBFirestore {
  String? uid;
  String? category;
  String? title;
  String? createUser;
  Map searchQuery = {};
  bool? indoor;
  bool? alone;
  bool? minor;
  String? lastImageUrl;
  int? number;
  Timestamp? createTime;
  Timestamp? updateTime;
  StoryDBFirestore();
  StoryDBFirestore.select(this.uid);
  StoryDBFirestore.create(
    this.category,
    this.title,
    this.indoor,
    this.alone,
    this.minor,
    this.createUser,
  );

  static const String _category = 'category';
  static const String _number = 'number';
  static const String _title = 'title';
  static const String _searchQuery = 'search_query';
  static const String _indoorSQ = 'indoor';
  static const String _aloneSQ = 'alone';
  static const String _minorSQ = 'minor';
  static const String _createUser = 'create_user';
  static const String _lastImageUrl = 'lastImageUrl';
  static const String _createTime = 'create_time';
  static const String _updateTime = 'update_time';

  static const _dbName = 'story';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _collection = _db.collection(_dbName);
  CollectionReference get collection => _collection;
  late DocumentReference document;

  // ドキュメント削除
  static Future<void> deleteDoc(List docIdList) async {
    List<Future<dynamic>> futureList = [];
    // QuerySnapshot snapshot =
    //     await _collection.where(_createUser, isEqualTo: userId).get();
    // List<QueryDocumentSnapshot> docs = snapshot.docs;

    for (QueryDocumentSnapshot doc in docIdList) {
      futureList.add(_collection.doc(doc.id).delete());
    }
    await Future.wait(futureList);
  }

  static String boolToStr(bool indoor, bool alone, bool minor) {
    String boolStr = '';
    for (bool b in [indoor, alone, minor]) {
      boolStr += b ? '1' : '0';
    }
    return boolStr;
  }

  static String getTitle(Map<String, dynamic> data) {
    return data[_title];
  }

  static String getCreateUser(Map<String, dynamic> data) {
    return data[_createUser];
  }

  // static String getCategory(Map<String, dynamic> data) {
  //   return data[_category];
  // }

  static String? getLastImageUrl(Map<String, dynamic> data) {
    return data[_lastImageUrl];
  }

  static CachedNetworkImage getLastImage(String imageUrl) {
    CachedNetworkImage image = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        // placeholder: (context, url) => Center(
        //     widthFactor: 1,
        //     heightFactor: 1,
        //     child: CircularProgressIndicator()),
        errorWidget: (context, url, dynamic error) {
          return Container();
        });
    return image;
  }

  static Timestamp getUpdateTime(Map<String, dynamic> data) {
    return data[_updateTime];
  }

  // static String? getLastImageUrl(Map<String, dynamic> data) {
  //   return data[_lastImageUrl];
  // }

  // static String? getLastImageUrl(Map<String, dynamic> data) {
  //   return data[_lastImageUrl];
  // }

  // Future<String> getTitle() async {
  //   try {
  //     final snapshot = await _collection.doc(uid).get();
  //     if (snapshot.data() != null) {
  //       return snapshot.get(_title);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return '';
  // }

  static Future<void> updateTimeSet(
      DocumentReference document, Timestamp time) async {
    await document.update({_updateTime: time});
  }

  static Future<void> updateLastImageSet(String uid, String imageUrl) async {
    await _collection.doc(uid).update({_lastImageUrl: imageUrl});
  }

  static Stream<QuerySnapshot> getStoryList(String userUid) {
    Stream<QuerySnapshot> stream = _collection
        // .orderBy(_updateTime)
        .where(_createUser, isEqualTo: userUid)
        .orderBy(_updateTime, descending: true)
        .snapshots();

    return stream;
  }

  static Future<QuerySnapshot> getStoryListRandomSearch(
      bool indoor, bool alone, bool minor, int limit) async {
    int maxNumber = await StoryIncrement.getMaxNumber();
    int mineStoryLength = CommonConfig.mine!.storyList.length;
    int otherNumber = mineStoryLength > limit ? mineStoryLength : limit;
    int randMinNumber =
        (maxNumber - otherNumber) < 1 ? 1 : (maxNumber - otherNumber);
    int minSearchNumber = math.Random().nextInt(randMinNumber);
    print('minSearchNumber===$minSearchNumber');

    final snapshot = await _collection
        // .where('group.indoor', isEqualTo: false)
        // .where(_searchQuery,
        //     isEqualTo: {_indoorSQ: true, _aloneSQ: true, _minorSQ: true})
        .where('$_searchQuery.$_indoorSQ', isEqualTo: indoor)
        .where('$_searchQuery.$_aloneSQ', isEqualTo: alone)
        .where('$_searchQuery.$_minorSQ', isEqualTo: minor)
        // .where('$_searchQuery.$_createUserSQ', isNotEqualTo: userUid)
        // .where('$_searchQuery.$_numberSQ', isGreaterThanOrEqualTo: 0)
        // .where(_boolArray, isNotEqualTo: '101')
        // .orderBy('$_searchQuery.test', descending: false)
        .orderBy(_number, descending: false)
        .startAt([minSearchNumber]) // 特定条件に合致するドキュメント以降を取得
        .limit(mineStoryLength + limit) // 自身の作成分も考慮
        .get();

    // // 最低のdocId取得
    // QuerySnapshot minSnapshot = await _collection
    //     .where(_number, isGreaterThan: minSearchNumber)
    //     .limit(1)
    //     .get();
    // final docs = minSnapshot.docs;
    // // データ取得
    // if (docs.length > 0) {
    //   final data = docs[0].data();
    //   final startPointDoc = await _collection.doc(docs[0].id).get();

    //   await _collection
    //       .orderBy(_number, descending: false)
    //       .startAtDocument(minSnapshot)
    //       .get();
    // }

    // // final snapshot =  _collection
    // //     .where(_createUser, isNotEqualTo: userUid)
    // //     .
    // //     .limit(limit + mineStoryLength);

    // QuerySnapshot snapshot = await _collection
    //     .where(_createUser, isNotEqualTo: userUid)
    //     // .where(_number, isGreaterThan: minSearchNumber)
    //     .limit(limit)
    //     .get();

    return snapshot;
  }

  Future<void> createStory() async {
    try {
      createTime = Timestamp.now();
      updateTime = createTime;
      DocumentReference doc = _collection.doc();
      int number = await StoryIncrement.autoIncrement();
      await doc.set({
        _number: number,
        _category: category,
        _title: title,
        _searchQuery: {
          _indoorSQ: indoor,
          _aloneSQ: alone,
          _minorSQ: minor,
        },
        _createUser: createUser,
        _createTime: createTime,
        _updateTime: updateTime,
      });
      uid = doc.id;
      // CollectionReference listCollection = document.collection('今日のサッカー');

      // String d = await document.set({_createTime: createTime, _updateTime: createTime});
      // CollectionReference collection = document.collection(_storyUid);
      // await document.set({_createTime: createTime, _updateTime: createTime});
      // .set({
      //   _userUid:userUid
      // })
      // await _collection.doc(uid).set({
      //   _name: name,
      //   _imagePath: imagePath,
      //   _createTime: createTime,
      //   _updateTime: createTime
      // });
    } catch (e) {
      print(e);
    }
  }

  // static Stream<QuerySnapshot> snapshot(String uid) {
  //   return _collection
  //       .doc(uid)
  //       .collection('message')
  //       .orderBy('send_time')
  //       .snapshots();
  // }

  // static Future<void> sendMessage(
  //     String uid, String userUid, String message) async {
  //   try {
  //     final messageCollection = _collection.doc(uid).collection('message');
  //     Timestamp nowTime = Timestamp.now();
  //     await messageCollection
  //         .add({'message': message, 'user': userUid, 'send_time': nowTime});

  //     _collection.doc(uid).update({_updateTime: nowTime});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> updateUser() async {
  //   try {
  //     await _collection.doc(uid).set({
  //       // _name: name,
  //       _imagePath: imagePath,
  //       _updateTime: Timestamp.now()
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<String> getUserName(String uid) async {
  //   try {
  //     final snapshot = await _collection.doc(uid).get();
  //     if (snapshot.data() != null) {
  //       return snapshot.get('name');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return '';
  // }

  // Stream<DocumentSnapshot<Object?>> userStream(String uid) {
  //   return _collection.doc(uid).snapshots();
  // }
// Add a new document with a generated ID
// _db.collection("users").add(user).then((DocumentReference doc) =>
//     print('DocumentSnapshot added with ID: ${doc.id}'));
//   // static final joinedRoomSnapshots =_roomCollection.where('joined_user_ids', arrayContains: SharedPrefs.fetchUid()).snapshots();
// }
}
