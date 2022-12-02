import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFileModel {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFileModel({
    required this.ref,
    required this.name,
    required this.url,
  });
}
