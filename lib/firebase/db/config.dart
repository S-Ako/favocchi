import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfigDBFirestore {
  static const _dbName = 'config';
  // static const String _sotryIncrement = 'StoryIncrement';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _collection = _db.collection(_dbName);
  static final DocumentReference _sotryIncrementDoc =
      _collection.doc('StoryIncrement');
}

class StoryIncrement {
  static String id = 'id';
  static Future<int> autoIncrement() async {
    DocumentSnapshot snapshot =
        await ConfigDBFirestore._sotryIncrementDoc.get();
    int number = (snapshot.data() as Map<String, dynamic>)[id];
    await ConfigDBFirestore._sotryIncrementDoc.update({id: number + 1});
    return number + 1;
  }

  static Future<int> minusIncrement(int minus) async {
    DocumentSnapshot snapshot =
        await ConfigDBFirestore._sotryIncrementDoc.get();
    int number = (snapshot.data() as Map<String, dynamic>)[id];
    await ConfigDBFirestore._sotryIncrementDoc.update({id: number - minus});
    return number - minus;
  }

  static Future<int> getMaxNumber() async {
    DocumentSnapshot snapshot =
        await ConfigDBFirestore._sotryIncrementDoc.get();
    int number = (snapshot.data() as Map<String, dynamic>)[id];
    return number;
  }
}
