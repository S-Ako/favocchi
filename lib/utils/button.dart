import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favocchi/utils/font.dart';
import 'package:get/get.dart';

import '../config/common.dart';
import 'space.dart';

class ButtonUtils {
  static BuildContext _context = CommonConfig().mainContext;
  static ThemeData _theme = Theme.of(_context);
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(100, 40),
    // Foreground color
    foregroundColor: _theme.colorScheme.onPrimary,
    // Background color
    backgroundColor: _theme.colorScheme.primary,
  );
  static ButtonStyle buttonStyleErr = ElevatedButton.styleFrom(
    minimumSize: Size(100, 40),
    // Foreground color
    foregroundColor: _theme.colorScheme.onError,
    // Background color
    backgroundColor: _theme.colorScheme.error,
  );
  static InkResponse defaultCircleButton(
      IconData icon, double size, Function() onTap,
      {bool isEnabled = true}) {
    return InkResponse(
        radius: size - SpaceUtils.smallSpace - SpaceUtils.smallHalfSpace,
        onTap: isEnabled ? onTap : null,
        child: Icon(
          color: isEnabled
              ? _theme.colorScheme.primary
              : _theme.colorScheme.onSurface.withOpacity(0.12),
          // _theme.colorScheme.primary,
          size: size,
          icon,
        ));
  }

  static Widget toggleRow(RxBool rxBool, IconData? tIcon, String tText,
      IconData? fIcon, String fText,
      {Color tColor = Colors.blue,
      Color fColor = Colors.red,
      bool isSmall = false,
      double? maxWidth}) {
    return Container(
      width: maxWidth,
      color:
          //  Colors.grey,
          CupertinoTheme.of(_context)
              .barBackgroundColor, //_theme.backgroundColor,
      child: Obx(
        () => CupertinoFormRow(
          padding: EdgeInsets.symmetric(
              vertical: 0, horizontal: SpaceUtils.smallQuarterSpace),
          // padding: EdgeInsets.all(SpaceUtils.smallQuarterSpace),
          prefix: Row(
            children: [
              Icon(
                size: isSmall ? FontUtils.h5Size! * 0.5 : FontUtils.h5Size,
                // Wifi icon is updated based on switch value.
                rxBool.value ? tIcon : fIcon,
                color: rxBool.value ? tColor : fColor,
              ),
              SizedBox(width: isSmall ? 0 : 10),
              rxBool.value
                  ? (isSmall ? FontUtils.small(tText) : FontUtils.body1(tText))
                  : (isSmall ? FontUtils.small(fText) : FontUtils.body1(fText)),
            ],
          ),
          child: Transform.scale(
            scaleX: isSmall ? 0.9 : 1,
            child: CupertinoSwitch(
              // This bool value toggles the switch.
              value: rxBool.value,
              thumbColor: rxBool.value ? tColor : fColor,
              trackColor: fColor.withOpacity(0.12),
              activeColor: tColor.withOpacity(0.12),
              onChanged: (bool? value) {
                // This is called when the user toggles the switch.
                rxBool.value = !rxBool.value;
              },
            ),
          ),
        ),
      ),
    );
  }

  static InkResponse gradientIconButton(
    IconData icon,
    Function? action, [
    double size = 50,
    Color? startColor,
    Color? endColor,
  ]) {
    startColor = startColor ?? Color(0xffe4a972).withOpacity(0.6);
    endColor = endColor ?? Color(0xff9941d8).withOpacity(0.6);
    return InkResponse(
      onTap: action == null ? null : () => action(),
      child: Container(
        // color: Colors.red,
        child: ShaderMask(
          child: Padding(
            padding: EdgeInsets.all(size / 3),
            child: Icon(
              icon,
              size: size,
              color: Colors.white,
            ),
          ),
          shaderCallback: (Rect rect) {
            return LinearGradient(
              colors: [
                startColor!,
                endColor!,
              ],
              stops: const [
                0.0,
                1.0,
              ],
            ).createShader(rect);
          },
        ),
      ),
    );
  }

  static InkResponse circleGradientButton(
    IconData icon,
    Function? action, [
    double size = 50,
    double borderWidth = 5,
  ]) {
    return InkResponse(
      onTap: action == null ? null : () => action(),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    const Color(0xffe4a972).withOpacity(0.6),
                    const Color(0xff9941d8).withOpacity(0.6),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ],
                ),
              )),
          Container(
              width: size - borderWidth * 2,
              height: size - borderWidth * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                color: Colors.white,
              )),
          ShaderMask(
            child: Icon(
              icon,
              size: size * 0.6,
              color: Colors.white,
            ),
            shaderCallback: (Rect rect) {
              return LinearGradient(
                colors: [
                  const Color(0xffe4a972).withOpacity(0.6),
                  const Color(0xff9941d8).withOpacity(0.6),
                ],
                stops: const [
                  0.0,
                  1.0,
                ],
              ).createShader(rect);
            },
          )
        ],
      ),
    );
  }

  static InkResponse roundGradientButton(
    IconData icon,
    Function action, {
    String title = '',
    double width = 200,
    double height = 50,
    double borderWidth = 5,
    double? iconSize,
  }) {
    return InkWell(
      radius: 3,
      onTap: () => action(),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    const Color(0xffe4a972).withOpacity(0.6),
                    const Color(0xff9941d8).withOpacity(0.6),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ],
                ),
              )),
          Container(
              width: width - borderWidth * 2,
              height: height - borderWidth * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              )),
          SizedBox(
            width: width,
            height: height,
            child: ShaderMask(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: iconSize == null ? height * 0.8 : iconSize,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: title == null ? 0 : 10,
                  ),
                  FontUtils.body1BoldWhite(title)
                  // Text(
                  //   title,
                  //   style: TextStyle(
                  //       color: Colors.white, //テキストの色を白に設定
                  //       fontSize: FontUtils.h5Size,
                  //       fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  colors: [
                    const Color(0xffe4a972).withOpacity(0.6),
                    const Color(0xff9941d8).withOpacity(0.6),
                  ],
                  stops: const [
                    0.0,
                    1.0,
                  ],
                ).createShader(rect);
              },
            ),
          )
        ],
      ),
    );
  }
}
