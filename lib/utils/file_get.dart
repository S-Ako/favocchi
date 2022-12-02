import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../export/firebase_storage.dart';

import '../config/common.dart';
import '../firebase/db/story.dart';
import '../firebase/db/story_message.dart';
import '../firebase/storage/story_message.dart';
import 'package:image_compression/image_compression.dart';

class FileGetUtils {
  static Future<List<String>> storyMessageMultiImage(
      String uid, String docId) async {
    List<String> multipleImages = [];
    List<XFile> _images = await _multiImagePicker();
    if (!CommonConfig.mine!.paid) {
      CommonConfig.noPaidSnackbar('画像投稿機能');
      return [];
    }
    if (_images.isNotEmpty) {
      // XFile cmpressImage = await pressImage(_images[_images.length - 1]);
      multipleImages = await _storyMessageMultiImage(_images, uid, docId);
    }
    return multipleImages;
  }

  // static Future<XFile> pressImage(XFile xFile) async {
  //   final bytes = await xFile.readAsBytes();
  //   final _image = ImageFile(
  //     rawBytes: bytes,
  //     filePath: xFile.path,
  //   );

  //   ImageFile image = compress(ImageFileConfiguration(
  //       input: _image,
  //       config: Configuration(
  //         pngCompression: PngCompression.bestCompression,
  //         jpgQuality: 10,
  //       )));

  //   return XFile(image.filePath);
  // }

  static Future<String> storyMessagePhoto(String uid, docId) async {
    String multipleImages = '';
    XFile? _images = await _imagePhoto();
    if (!CommonConfig.mine!.paid) {
      CommonConfig.noPaidSnackbar('写真投稿機能');
      return '';
    }

    if (_images != null) {
      multipleImages = await _storyMessagePhoto(_images, uid, docId);
    }
    return multipleImages;
  }

  static Future<XFile?> _imagePhoto() async {
    XFile? _images = await ImagePicker().pickImage(source: ImageSource.camera);
    return _images;
  }

  static Future<List<XFile>> _multiImagePicker() async {
    List<XFile> _images = await ImagePicker().pickMultiImage();
    if (_images.isNotEmpty) {
      return _images;
    }
    return [];
  }

  static Future<String> _storyMessagePhoto(XFile image, uid, docId) async {
    String _path = '';
    _path = await StoryMessageStorageFirebase.uploadImage(image, uid);
    await StoryMessageDBFirestore.sendMessage(uid, imagePath: _path);
    if (_path.length > 0) {
      StoryDBFirestore.updateLastImageSet(docId, _path);
    }
    return _path;
  }

  static Future<List<String>> _storyMessageMultiImage(
      List<XFile> list, uid, docId) async {
    List<String> _path = [];
    for (XFile _image in list) {
      String finishPath =
          await StoryMessageStorageFirebase.uploadImage(_image, uid);
      _path.add(finishPath);
      await StoryMessageDBFirestore.sendMessage(uid, imagePath: finishPath);
    }
    if (_path.length > 0) {
      String lastImageUrl = _path[_path.length - 1];
      StoryDBFirestore.updateLastImageSet(docId, lastImageUrl);
    }
    return _path;
  }

  // static Future<void> _storylastImage(XFile image, uid) async {
  //   String finishPath =
  //       await StoryMessageStorageFirebase.uploadLastImage(image, uid);
  //   // await StoryMessageDBFirestore.sendMessage(uid, imagePath: finishPath);
  // }
}
