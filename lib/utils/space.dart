import 'package:flutter/cupertino.dart';

class SpaceUtils {
  static const double bigSpace = 30;
  static const double normalSpace = 20;
  static const double smallSpace = 10;
  static const double smallHalfSpace = smallSpace / 2;
  static const double smallQuarterSpace = smallSpace / 4;

  static const bigY = SizedBox(height: bigSpace);
  static const normalY = SizedBox(height: normalSpace);
  static const smallY = SizedBox(height: smallSpace);
  static const smallHalfSpaceY = SizedBox(height: smallHalfSpace);
  static const smallQuarterSpaceY = SizedBox(height: smallQuarterSpace);

  static const bigX = SizedBox(width: bigSpace);
  static const normalX = SizedBox(width: normalSpace);
  static const smallX = SizedBox(width: smallSpace);
  static const smallHalfSpaceX = SizedBox(width: smallHalfSpace);
  static const smallQuarterSpaceX = SizedBox(width: smallQuarterSpace);

  static Padding Function(Widget) bigPadding = (Widget child) {
    return Padding(
      padding: EdgeInsets.all(bigSpace),
      child: child,
    );
  };
  static Padding Function(Widget) normalPadding = (Widget child) {
    return Padding(
      padding: EdgeInsets.all(normalSpace),
      child: child,
    );
  };
  static Padding Function(Widget) smallPadding = (Widget child) {
    return Padding(
      padding: EdgeInsets.all(smallSpace),
      child: child,
    );
  };
}
