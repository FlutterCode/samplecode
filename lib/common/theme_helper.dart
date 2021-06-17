import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme_dimensions.dart';

class ThemeHelper {
  static Widget paddingOnly(
          {paddingTop = ThemeDimension.paddingZero,
          paddingBottom = ThemeDimension.paddingZero,
          paddingLeft = ThemeDimension.paddingZero,
          paddingRight = ThemeDimension.paddingZero}) =>
      Padding(
          padding: EdgeInsets.only(
              top: paddingTop,
              bottom: paddingBottom,
              left: paddingLeft,
              right: paddingRight));

  static Widget paddingTop({double padding = ThemeDimension.paddingSmall}) =>
      Padding(padding: EdgeInsets.only(top: padding));

  static Widget paddingLeftTiny(
          {double padding = ThemeDimension.paddingTiny}) =>
      Padding(padding: EdgeInsets.only(left: padding));

  static Widget paddingHorizontal({padding = ThemeDimension.paddingSmall}) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: padding));

  static TextStyle titleStyle(BuildContext context,
          {Color color,
          FontWeight weight: FontWeight.normal,
          double letterSpacing = 0,
          double fontSize = 20}) =>
      Theme.of(context).textTheme.headline6.copyWith(
          color: color ?? Theme.of(context).textTheme.headline6.color,
          fontWeight: weight,
          fontSize: fontSize,
          letterSpacing: letterSpacing);

  static TextStyle body1Style(BuildContext context,
          {Color color,
          FontWeight weight: FontWeight.normal,
          double fontSize = 14,
          double letterSpacing = 0}) =>
      Theme.of(context).textTheme.bodyText2.copyWith(
          color: color ?? Theme.of(context).textTheme.bodyText2.color,
          fontWeight: weight,
          fontSize: fontSize,
          letterSpacing: letterSpacing);

  static Text titleText(BuildContext context, String text,
      {TextStyle style, TextAlign textAlign = TextAlign.start, int maxLines}) {
    return Text(text,
        style: style ?? titleStyle(context),
        textAlign: textAlign,
        maxLines: maxLines);
  }

  static Text body1TextWithColor(BuildContext context, String text,
      {TextStyle style,
      TextAlign textAlign = TextAlign.start,
      int maxLines,
      Color color = kColorBlack}) {
    return Text(text,
        style: style ?? body1Style(context, color: color),
        textAlign: textAlign,
        maxLines: maxLines);
  }

  static TextStyle textFormFieldStyle(BuildContext context,
          {FontWeight weight = FontWeight.w500, Color color = kColorBlack}) =>
      body1Style(context, weight: weight, color: kColorBlack);

  static InputDecoration textFieldInputDecoration(
      BuildContext context, String hintText,
      {String editTextValue = "",
      VoidCallback onCancelClick,
      bool hasFocus = false}) {
    print(editTextValue);
    return InputDecoration(
      hintStyle: TextStyle(color: kColorBlack),
      suffix: InkWell(
          onTap: onCancelClick,
          child: Icon(
            Icons.cancel,
            color: hasFocus
                ? (editTextValue != null && editTextValue.isNotEmpty)
                    ? kColorGrey
                    : Colors.transparent
                : Colors.transparent,
          )),
      labelText: hintText ?? "",
      labelStyle: TextStyle(color: kColorBlack),
    );
  }
}
