import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:favocchi/utils/font.dart';
import 'package:favocchi/utils/space.dart';
import 'package:intl/intl.dart' as intl;

import '../config/common.dart';

class CardUtils {
  static ThemeData _theme = Theme.of(CommonConfig().mainContext);
  static Card create(Function onTap, String title, DateTime date,
      {double width = 300, double height = 80, dynamic image}) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
            onTap: () {
              onTap();
            },
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      width: width,
                      height: height,
                      child: FittedBox(fit: BoxFit.cover, child: image),
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(color: Colors.white),
                      clipBehavior: Clip.antiAlias,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(SpaceUtils.smallSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontUtils.edgeTextLine(title, 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FontUtils.edgeTextLine(
                                  '更新日：${intl.DateFormat('yyyy/MM/dd').format(date)}',
                                  10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // widget
                ],
              ),
            )));
  }
}
