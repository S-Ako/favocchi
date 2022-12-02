import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDBFirestore {
  String uid;
  String name = '';
  String imagePath = '';
  List<dynamic> storyList = [];
  Timestamp? createTime;
  Timestamp? updateTime;
  bool testMode = false;
  bool admin = false;
  bool paid = false;

  UserDBFirestore(this.uid) {}

  static const String _name = 'name';
  static const String _imagePath = 'image_path';
  static const String _storyList = 'story_list';
  static const String _createTime = 'create_time';
  static const String _updateTime = 'update_time';
  static const String _testMode = 'test_mode';
  static const String _admin = 'admin';
  static const String _paid = 'paid';

  Map<String, dynamic> getUserMap() {
    return {
      _name: name,
      _imagePath: imagePath,
      _storyList: storyList,
      _createTime: createTime,
      _updateTime: updateTime,
      _testMode: testMode,
      _admin: admin,
      _paid: paid,
    };
  }

  Future<void> init() async {
    final snapshot = await _collection.doc(uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      name = data![_name] ?? '';
      imagePath = data![_imagePath] ?? '';
      storyList = data![_storyList] ?? [];
      createTime = data![_createTime] as Timestamp?;
      updateTime = data![_updateTime] as Timestamp?;
      testMode = data![_testMode] ?? false;
      admin = data![_admin] ?? false;
      paid = data![_paid] ?? false;
    }
  }

  static const _dbName = 'user';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _collection = _db.collection(_dbName);

  // ドキュメント削除
  Future<void> deleteDoc() async {
    await _collection.doc(uid).delete();
  }

  Future<void> delete() async {}

  Future<void> addUserStoryList(String storyUid) async {
    try {
      storyList!.add(storyUid);
      await _collection.doc(uid).update({
        _storyList: FieldValue.arrayUnion([storyUid])
      });

      // collection(_storyList).doc(storyUid);
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> getStoryList() async {
    final snapshot = await _collection.doc(uid).get();
    if (snapshot.data() != null) {
      return snapshot.get(_storyList);
    }
    return [];
  }

  static Future<void> createUser(
      String uid, String name, String imagePath) async {
    try {
      Timestamp createTime = Timestamp.now();
      Timestamp updateTime = createTime;
      await _collection.doc(uid).set({
        _name: name,
        _imagePath: imagePath,
        _storyList: [],
        _createTime: createTime,
        _updateTime: updateTime,
        _testMode: false,
        _admin: false,
        _paid: false,
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> updateUser() async {
  //   try {
  //     updateTime = Timestamp.now();
  //     await _collection.doc(uid).set({
  //       // _name: name,
  //       _imagePath: imagePath,
  //       _updateTime: updateTime
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<String> getUserName() async {
  //   try {
  //     final snapshot = await _collection.doc(uid).get();
  //     if (snapshot.data() != null) {
  //       return snapshot.get(_name);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return '';
  // }

  Stream<DocumentSnapshot<Object?>> userStream(String uid) {
    return _collection.doc(uid).snapshots();
  }
// Add a new document with a generated ID
// _db.collection("users").add(user).then((DocumentReference doc) =>
//     print('DocumentSnapshot added with ID: ${doc.id}'));
//   // static final joinedRoomSnapshots =_roomCollection.where('joined_user_ids', arrayContains: SharedPrefs.fetchUid()).snapshots();
// }
}
