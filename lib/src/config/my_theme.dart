import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../styles/style.dart';

class MyTheme {
  static const String fontFamily = 'Roboto';

  final bool _isLightMode =
      SchedulerBinding.instance!.window.platformBrightness == Brightness.light;

  bool get isLightMode => _isLightMode;

  static ThemeData lightTheme() {
    return ThemeData(
      backgroundColor: MyColors.backgroundColorLight,
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: MyColors.scaffoldBackgroundColorLight,
      shadowColor: Colors.grey.shade200,
      colorScheme: const ColorScheme(
        secondary: MyColors.secondaryColor,
        primary: MyColors.primaryColor,
        background: MyColors.backgroundColorLight,
        brightness: Brightness.light,
        error: MyColors.errorColor,
        onBackground: MyColors.backgroundColorLight,
        onError: MyColors.errorColor,
        onPrimary: MyColors.whiteColor,
        onSecondary: MyColors.secondaryColor,
        onSurface: MyColors.whiteColor,
        secondaryVariant: MyColors.whiteColor,
        surface: MyColors.whiteColor,
        primaryVariant: MyColors.whiteColor,
      ),

      errorColor: MyColors.errorColor,
      primaryIconTheme:
          const IconThemeData(color: MyColors.primaryColor, size: 24),

      // Text
      primaryTextTheme: const TextTheme(
        headline1: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize25,
          fontWeight: FontWeight.w700,
          color: MyColors.blackColor,
        ),
        headline2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w700,
          color: MyColors.blackColor,
        ),
        headline3: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w400,
          color: MyColors.blackColor,
        ),
        headline4: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize16,
          fontWeight: FontWeight.w600,
          color: MyColors.greyTextColor2,
        ),
        headline5: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize16,
          fontWeight: FontWeight.w600,
          color: MyColors.primaryColor,
        ),
        headline6: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.primaryColor,
        ),
        bodyText1: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w600,
          color: MyColors.blackColor,
        ),
        bodyText2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.blackColor,
        ),
        subtitle1: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.greyTextColor1,
        ),
        subtitle2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize12,
          fontWeight: FontWeight.w600,
          color: MyColors.greyTextColor2,
        ),
        // caption: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize10,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.greyTextColor,
        // ),
        button: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize16,
          fontWeight: FontWeight.w600,
          color: MyColors.whiteColor,
        ),
      ),
      textTheme: const TextTheme(
        // headline1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize18,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        headline2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w700,
          color: MyColors.primaryColor,
        ),
        // bodyText1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize18,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        // bodyText2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.blackColor,
        // ),
        subtitle1: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.primaryColor,
        ),
        // subtitle2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.primaryColor,
        // ),
        // headline2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.whiteColor,
        // ),
        // headline3: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize19,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.blackColor,
        // ),
        // headline4: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        // headline6: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w500,
        //   color: MyColors.whiteColor,
        // ),
        // caption: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.whiteColor,
        // ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      backgroundColor: MyColors.backgroundColorLight,
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: MyColors.scaffoldBackgroundColorLight,
      shadowColor: Colors.grey.shade200,

      colorScheme: const ColorScheme(
        secondary: MyColors.secondaryColor,
        primary: MyColors.primaryColor,
        background: MyColors.backgroundColorLight,
        brightness: Brightness.light,
        error: MyColors.errorColor,
        onBackground: MyColors.blackColor,
        onError: MyColors.errorColor,
        onPrimary: MyColors.primaryColor,
        onSecondary: MyColors.secondaryColor,
        onSurface: MyColors.whiteColor,
        primaryVariant: MyColors.blackColor,
        secondaryVariant: MyColors.blackColor,
        surface: MyColors.blackColor,
      ),

      errorColor: MyColors.errorColor,
      primaryIconTheme:
          const IconThemeData(color: MyColors.primaryColor, size: 24),

      // Text
      primaryTextTheme: const TextTheme(
        // headline1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize24,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.greyTextColor1,
        // ),
        // headline3: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w600,
        //   color: MyColors.primaryColor,
        // ),
        // bodyText1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.blackColor,
        // ),
        // bodyText2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize8,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.blackColor,
        // ),
        // headline5: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize10,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.blackColor,
        // ),
        // subtitle1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w500,
        //   color: MyColors.whiteColor,
        // ),
        // subtitle2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w500,
        //   color: MyColors.blackColor,
        // ),
        // caption: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize10,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.greyTextColor1,
        // ),
        // headline4: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize13,
        //   fontWeight: FontWeight.w500,
        //   color: MyColors.whiteColor,
        // ),
        // headline6: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize16,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.greyTextColor1,
        // ),
        // headline2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
      ),
      textTheme: const TextTheme(
        // headline1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize22,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        // bodyText1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.whiteColor,
        // ),
        // bodyText2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.whiteColor,
        // ),
        // subtitle1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.whiteColor,
        // ),
        // subtitle2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.primaryColor,
        // ),
        // headline2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.whiteColor,
        // ),
        // headline3: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize19,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.blackColor,
        // ),
        // headline4: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        // headline6: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize14,
        //   fontWeight: FontWeight.w500,
        //   color: MyColors.whiteColor,
        // ),
        // caption: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.blackColor,
        // ),
      ),
    );
  }
}
