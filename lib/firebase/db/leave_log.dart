import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favocchi/firebase/db/story.dart';
import 'package:favocchi/firebase/db/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;

import '../auth.dart';
import '../storage/story_message.dart';
import 'config.dart';

class LeaveLogDBFirestore {
  String? year;
  String? mmdd;
  UserDBFirestore? user;
  LeaveLogDBFirestore() {}

  static const _dbName = 'leaveLog';
  static const _leaveTime = 'leave_Time';
  static const _email = 'email';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _collection = _db.collection(_dbName);

  Future<void> leave(UserDBFirestore _user) async {
    user = _user;
    Timestamp nowTime = Timestamp.now();
    DateTime nowDate = nowTime.toDate();
    year = intl.DateFormat('yyyy').format(nowDate);
    mmdd = intl.DateFormat('MMdd').format(nowDate);

    // ユーザー情報
    Map<String, dynamic> setMap = user!.getUserMap();
    setMap[_leaveTime] = nowTime;
    setMap[_email] = FirebaseAuth.instance.currentUser!.email;

    // ログに登録
    CollectionReference mmddCollection =
        _collection.doc(year).collection(mmdd!);
    await mmddCollection.doc(user!.uid).set(setMap);

    // 削除処理
    await Future.wait([
      // ユーザー情報削除
      user!.deleteDoc(),
      // ドキュメント削除
      StoryDBFirestore.deleteDoc(user!.storyList),
      // firebaseStorage削除
      StoryMessageStorageFirebase.userUploadDelete(user!.uid),
      // config削除
      // StoryIncrement.minusIncrement(user!.storyList.length)
    ]);

    // firebaseAuth削除
    await AuthFirebase.userDelete(FirebaseAuth.instance.currentUser!);
  }
}
