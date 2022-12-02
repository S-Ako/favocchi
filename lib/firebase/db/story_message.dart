import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favocchi/firebase/db/story.dart';
import 'package:favocchi/utils/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tuple/tuple.dart';

import '../../utils/font.dart';

class StoryMessageDBFirestore {
  String messageUid;
  String? message;
  String? image;
  String createUser;
  Timestamp? createTime;

  static const _collectionName = 'message';
  static const _message = 'message';
  static const _image = 'image';
  static const _createUser = 'create_user';
  static const _createTime = 'create_time';
  static late DocumentReference _doc;
  static late CollectionReference _collection;
  static late Stream<QuerySnapshot> _snapshot;

  DocumentReference get doc => _doc;
  Stream<QuerySnapshot> get snapshot => _snapshot;

  StoryMessageDBFirestore(this.messageUid, this.createUser) {
    _doc = StoryDBFirestore().collection.doc(messageUid);
    _collection = _doc.collection(_collectionName);
    _snapshot = _collection.orderBy(_createTime, descending: true).snapshots();
  }

  static Timestamp getTime(Map<String, dynamic> data) {
    return data[_createTime];
  }

  static getType(Map<String, dynamic> data) {
    if (data[_message] != null) {
      return String;
    } else if (data[_image] != null) {
      return CachedNetworkImage;
    }
  }

  static String? getUrl(Map<String, dynamic> data) {
    if (data[_image] != null) {
      return data[_image];
    }
    return null;
  }

  static String? getMessage(Map<String, dynamic> data) {
    if (data[_message] != null) {
      return data[_message];
    }
    return null;
  }

  /// svg
  static dynamic ____getMessage(Map<String, dynamic> data,
      {BoxFit fit = BoxFit.contain}) async {
    Type type = getType(data);
    if (type == String) {
      return data[_message] as String;
    } else if (type == CachedNetworkImage) {
      try {
        return CachedNetworkImage(
            // cacheKey: data[_image],
            // imageBuilder: (context, imageProvider) {
            //   // imageProvider.imageRenderMethodForWeb
            //   return Container(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: imageProvider,
            //         fit: BoxFit.cover,
            //         colorFilter: const ColorFilter.mode(
            //           Colors.red,
            //           BlendMode.colorBurn,
            //         ),
            //       ),
            //     ),
            //   );
            // },
            imageUrl:
                // 'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?fit=bounds&format=jpeg&quality=85&width=330',
                data[_image],
            placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
            errorWidget: (context, url, dynamic error) {
              return Row(
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
              );
            });
        // Image.network(
        //   data[_image],
        //   fit: fit,
        //   errorBuilder: (c, o, s) {
        //     print(c);
        //     return Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Icon(
        //           Icons.error,
        //           color: Colors.red,
        //         ),
        //         SpaceUtils.smallX,
        //         FontUtils.body1('画像が読み込めませんでした'),
        //       ],
        //     );
        //   },
        // );
      } catch (e) {
        print(e);
      }
      //data[_image];
    }
    return '';
    // if (data.containsKey(_message)) {}
    // List<String> fields = [_message, _image];
    // for (String field in fields) {
    //   if (data[field] != null) return data[field];
    // }
  }

  static Future<void> sendMessage(String userUid,
      {String? message, String? imagePath}) async {
    try {
      Timestamp nowTime = Timestamp.now();
      await _collection.add({
        _message: message,
        _image: imagePath,
        _createUser: userUid,
        _createTime: nowTime
      });
      await StoryDBFirestore.updateTimeSet(_doc, nowTime);
    } catch (e) {
      print(e);
    }
  }
}
