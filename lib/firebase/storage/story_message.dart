import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:mime/mime.dart';

import '../../export/firebase_storage.dart';

// import '../../export/common/firebase_storage.dart';

class StoryMessageStorageFirebase {
  static String folderName = 'story';

  static Future<dynamic> userUploadDelete(String userId) async {
    List<Future<void>> list = [];
    Reference db = FirebaseStorage.instance.ref('$folderName/$userId');

    await db.listAll().then((value) {
      value.items.forEach((element) {
        list.add(FirebaseStorage.instance.ref(element.fullPath).delete());
      });
    });
    await Future.wait(list);

    // Reference db = FirebaseStorage.instance.ref('$folderName/$userId');
    // await db.delete();
  }

  static Future<String> uploadImage(XFile image, String userId,
      {String imagePath = ''}) async {
    String? mimeType = lookupMimeType(image.path);

    imagePath = imagePath == '' ? basename(image.path) : imagePath;
    Reference db =
        FirebaseStorage.instance.ref('$folderName/$userId/$imagePath');
    try {
      await FirebaseStorageExport().putFileData(db, image);
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    try {
      return await db.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return await db.getDownloadURL();
  }

  // static Future<String> uploadLastImage(XFile image, String messageUid) async {
  //   return await uploadImage(image, messageUid, imagePath: '/$lastImageName');
  // }
}
