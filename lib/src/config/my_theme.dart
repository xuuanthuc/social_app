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
      primaryColorLight: MyColors.primaryColor10,
      colorScheme: ColorScheme(
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
        secondaryVariant: Colors.grey,
        surface: MyColors.whiteColor,
        primaryVariant: Colors.grey.shade200,
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
          height: 1.3,
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
      textTheme: TextTheme(
        // headline1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize18,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        headline2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w700,
          color: MyColors.primaryColor,
        ),
        headline5: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize16,
          fontWeight: FontWeight.w600,
          color: MyColors.blackColor,
        ),
        headline6: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.blackColor,
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
        subtitle1: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.primaryColor,
        ),
        bodyText2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          height: 1.3,
          color: MyColors.whiteColor,
        ),
        // subtitle2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.primaryColor,
        // ),
        subtitle2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize10,
          fontWeight: FontWeight.w400,
          color: MyColors.greyTextColor1,
        ),
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
        caption: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize10,
          fontWeight: FontWeight.w400,
          color: MyColors.whiteColor.withOpacity(0.8),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      backgroundColor: MyColors.backgroundColorDark,
      primaryColor: MyColors.primaryColor,
      scaffoldBackgroundColor: MyColors.scaffoldBackgroundColorDark,
      shadowColor: MyColors.primaryColorDark,
      primaryColorLight: MyColors.primaryColorDark,
      colorScheme: const ColorScheme(
        secondary: MyColors.secondaryColor,
        primary: MyColors.primaryColor,
        background: MyColors.backgroundColorDark,
        brightness: Brightness.dark,
        error: MyColors.errorColor,
        onBackground: MyColors.blackColor,
        onError: MyColors.errorColor,
        onPrimary: MyColors.primaryColor,
        onSecondary: MyColors.secondaryColor,
        onSurface: MyColors.whiteColor,
        secondaryVariant: MyColors.blackColor,
        surface: MyColors.backgroundColorDark,
        primaryVariant: MyColors.scaffoldBackgroundColorDark,
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
          color: MyColors.whiteColor,
        ),
        headline2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w700,
          color: MyColors.whiteColor,
        ),
        headline3: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w400,
          color: MyColors.whiteColor,
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
          color: MyColors.whiteColor,
        ),
        bodyText2: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          height: 1.3,
          color: MyColors.whiteColor,
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
      textTheme: TextTheme(
        // headline1: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize18,
        //   fontWeight: FontWeight.w700,
        //   color: MyColors.primaryColor,
        // ),
        headline2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize18,
          fontWeight: FontWeight.w700,
          color: MyColors.primaryColor,
        ),
        headline5: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize16,
          fontWeight: FontWeight.w600,
          color: MyColors.whiteColor,
        ),
        headline6: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.whiteColor,
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
        subtitle1: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          color: MyColors.primaryColor,
        ),
        bodyText2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize13,
          fontWeight: FontWeight.w400,
          height: 1.3,
          color: MyColors.blackColor,
        ),
        // subtitle2: TextStyle(
        //   fontFamily: fontFamily,
        //   fontSize: Dimens.textSize12,
        //   fontWeight: FontWeight.w400,
        //   color: MyColors.primaryColor,
        // ),
        subtitle2: const TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize10,
          fontWeight: FontWeight.w400,
          color: MyColors.greyTextColor1,
        ),
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
        caption: TextStyle(
          fontFamily: fontFamily,
          fontSize: Dimens.textSize10,
          fontWeight: FontWeight.w400,
          color: MyColors.blackColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
