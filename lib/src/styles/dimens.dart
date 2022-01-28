import 'package:flutter/material.dart';

import 'colors.dart';

class Dimens {
  static const double size0 = 0.0;
  static const double size1 = 1.0;
  static const double size2 = 2.0;
  static const double size3 = 3.0;
  static const double size4 = 4.0;
  static const double size5 = 5.0;
  static const double size6 = 6.0;
  static const double size7 = 7.0;
  static const double size8 = 8.0;
  static const double size10 = 10.0;
  static const double size11 = 11.0;
  static const double size12 = 12.0;
  static const double size13 = 13.0;
  static const double size14 = 14.0;
  static const double size15 = 15.0;
  static const double size16 = 16.0;
  static const double size17 = 17.0;
  static const double size18 = 18.0;
  static const double size19 = 19.0;
  static const double size20 = 20.0;
  static const double size22 = 22.0;
  static const double size23 = 23.0;
  static const double size24 = 24.0;
  static const double size25 = 25.0;
  static const double size26 = 26.0;
  static const double size27 = 27.0;
  static const double size28 = 28.0;
  static const double size30 = 30.0;
  static const double size32 = 32.0;
  static const double size34 = 34.0;
  static const double size35 = 35.0;
  static const double size36 = 36.0;
  static const double size38 = 38.0;
  static const double size40 = 40.0;
  static const double size42 = 42.0;
  static const double size41 = 41.0;
  static const double size44 = 44.0;
  static const double size45 = 45.0;
  static const double size46 = 46.0;
  static const double size48 = 48.0;
  static const double size50 = 50.0;
  static const double size52 = 52.0;
  static const double size54 = 54.0;
  static const double size55 = 55.0;
  static const double size56 = 56.0;
  static const double size58 = 58.0;
  static const double size60 = 60.0;
  static const double size62 = 62.0;
  static const double size64 = 64.0;
  static const double size68 = 68.0;
  static const double size70 = 70.0;
  static const double size72 = 72.0;
  static const double size74 = 74.0;
  static const double size75 = 75.0;
  static const double size76 = 76.0;
  static const double size77 = 77.0;
  static const double size78 = 78.0;
  static const double size80 = 80.0;
  static const double size82 = 82.0;
  static const double size87 = 87.0;
  static const double size84 = 84.0;
  static const double size88 = 88.0;
  static const double size90 = 90.0;
  static const double size96 = 96.0;
  static const double size100 = 100.0;
  static const double size105 = 105.0;
  static const double size110 = 110.0;
  static const double size120 = 120.0;
  static const double size128 = 128.0;
  static const double size130 = 130.0;
  static const double size140 = 140.0;
  static const double size144 = 144.0;
  static const double size150 = 150.0;
  static const double size160 = 160.0;
  static const double size170 = 170.0;
  static const double size168 = 168.0;
  static const double size180 = 180.0;
  static const double size190 = 190.0;
  static const double size200 = 200.0;
  static const double size220 = 220.0;
  static const double size250 = 250.0;
  static const double size260 = 260.0;
  static const double size265 = 265.0;
  static const double size270 = 270.0;
  static const double size280 = 280.0;
  static const double size288 = 288.0;
  static const double size300 = 300.0;
  static const double size387 = 387.0;
  static const double size400 = 400.0;
  static const double size420 = 420.0;
  static const double size442 = 442.0;
  static const double size470 = 470.0;
  static const double size530 = 530.0;

  ///
  static const double thickness = 1.0;
  static const double strokeWidth = 2.5;
  static const double controlHeight = 44.0;
  static const double controlWidth = 180.0;
  static const double iconSize = 24.0;
  static const double titlePopSize = 18.0;
  static const double iconSizeInside = 20.0;
  static const double spacing = 12.0;
  static const int breakpoint = 1920;
  static const double defaultBorderRadius = 10;
  static const double cardBorderRadius = 20;
  static const double verticalSpacingBetween = 20.0;
  static const double horizontalSpacingBetween = 90.0;
  static const paddingAll = EdgeInsets.all(spacing);
  static const paddingVertical = EdgeInsets.symmetric(vertical: spacing);
  static const paddingHorizontal = EdgeInsets.symmetric(horizontal: spacing);
  static const paddingBottom = EdgeInsets.only(bottom: 0.0);
  static const buttonPadding =
      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0);
  static const mainPagePadding =
      EdgeInsets.symmetric(horizontal: 71.0, vertical: 20.0);
  static const mainTopPagePadding =
      EdgeInsets.only(left: 71.0, right: 71.0, top: 34);

  static const lineWeight = 2.0;
  // static const cardShadow = BoxShadow(
  //   color: MyColors.colorShadow,
  //   spreadRadius: 2,
  //   blurRadius: 3,
  //   offset: Offset(0, 3), // changes position of shadow
  // );
  static const lightWeightCardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05), //INFO: Cannot get from MyColor.
    spreadRadius: 0,
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const gradientText = LinearGradient(
    colors: [
      MyColors.secondaryColor,
      MyColors.primaryColor,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientDone = LinearGradient(
    colors: [
      MyColors.secondaryColor,
      MyColors.primaryColor,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const productCardHight = 660.0;
  static const productCardWidth = 384.0;

  static const double phoneVerificationCardWidth = 459.0;
  static const double mainAxisExtentListContact = 302.0;
  static const int crossAxisCountListContact = 2;
  static const int crossAxisCountListRecord = 3;

  // Text size;
  static const textSize8 = 8.0;
  static const textSize10 = 10.0;
  static const textSize11 = 11.0;
  static const textSize12 = 12.0;
  static const textSize13 = 13.0;
  static const textSize14 = 14.0;
  static const textSize15 = 15.0;
  static const textSize16 = 16.0;
  static const textSize17 = 17.0;
  static const textSize18 = 18.0;
  static const textSize19 = 19.0;
  static const textSize20 = 20.0;
  static const textSize22 = 22.0;
  static const textSize24 = 24.0;
  static const textSize25 = 25.0;
  static const textSize26 = 26.0;
  static const textSize27 = 27.0;
  static const textSize28 = 28.0;
  static const textSize30 = 30.0;

  /// Icon size
  static const double smallIconSize = 16.0;
  static const double normalIconSize = 24.0;
  static const double largeIconSize = 56.0;
}
