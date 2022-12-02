// import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageExport {
  Future<void> putFileData(Reference db, XFile image) async {
    await db.putData(
      await image.readAsBytes(),
      SettableMetadata(contentType: image.mimeType),
    );
  }
}
