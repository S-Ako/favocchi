import 'package:flutter/material.dart';

import '../config/common.dart';

class FontUtils {
  static late BuildContext mainContext;
  static const double _letterTitleSpacing = 2;
  static const double _letterMessageSpacing = 0.5;
  static final ThemeData _theme = Theme.of(CommonConfig().mainContext);
  static final TextTheme _textTheme = _theme.textTheme;
  static final double? h4Size = _textTheme.headline4!.fontSize;
  static final double? h5Size = _textTheme.headline5!.fontSize;
  // static final Color fontColor = _textTheme.bodyText1!.color!;
  static Text bodyTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: _textTheme.headline6!.fontSize,
        fontFamily: CommonConfig.fontFamily,
        letterSpacing: _letterTitleSpacing,
        // color: fontColor,
      ),
    );
  }

  static Text bodyMsg(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: _textTheme.subtitle1!.fontSize,
        fontFamily: CommonConfig.fontFamily,
        letterSpacing: _letterMessageSpacing,
      ),
    );
  }

  static Text secondColorText(String text) {
    return Text(
      text,
      // style: TextStyle(color: CommonConfig.secondaryColor),
    );
  }

  static Stack edgeTextLine(String title, double fontSize) {
    return Stack(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.white,
          ),
        ),
        // Solid text as fill.
        Text(
          title,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  static Text h1(String text) {
    return Text(text,
        style: TextStyle(
          fontSize: _textTheme.headline1!.fontSize,
          fontFamily: CommonConfig.fontFamily,
        ));
  }

  static Text h2(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.headline2!.fontSize));
  }

  static Text h3(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.headline3!.fontSize));
  }

  static Text h4(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.headline4!.fontSize));
  }

  static Text h5(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.headline5!.fontSize));
  }

  static Text h6(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.headline6!.fontSize));
  }

  static Text sub1(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.subtitle1!.fontSize));
  }

  static Text sub2(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.subtitle2!.fontSize));
  }

  static Text body1(String text) {
    return Text(text,
        style: TextStyle(
          fontSize: _textTheme.bodyText1!.fontSize,
          fontFamily: CommonConfig.fontFamily,
        ));
  }

  static Text small(String text) {
    return Text(text,
        style: TextStyle(
          fontSize: _textTheme.bodyText1!.fontSize! * 0.8,
          fontFamily: CommonConfig.fontFamily,
        ));
  }

  static Text body1Bold(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: _textTheme.bodyText1!.fontSize,
            fontFamily: CommonConfig.fontFamily,
            fontWeight: FontWeight.bold));
  }

  static Text body1BoldWhite(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: _textTheme.bodyText1!.fontSize,
            fontFamily: CommonConfig.fontFamily,
            fontWeight: FontWeight.bold,
            color: Colors.white));
  }

  static Text body1White(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: _textTheme.bodyText1!.fontSize,
            fontFamily: CommonConfig.fontFamily,
            // fontWeight: FontWeight.bold,
            color: Colors.white));
  }

  static Text body1Err(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: _textTheme.bodyText1!.fontSize,
            fontFamily: CommonConfig.fontFamily,
            color: _theme.errorColor));
  }

  static Text body2(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.bodyText2!.fontSize));
  }

  static Text button(String text) {
    return Text(text, style: TextStyle(fontSize: _textTheme.button!.fontSize));
  }

  static Text caption(String text) {
    return Text(text, style: TextStyle(fontSize: _textTheme.caption!.fontSize));
  }

  static Text overline(String text) {
    return Text(text,
        style: TextStyle(fontSize: _textTheme.overline!.fontSize));
  }
}
