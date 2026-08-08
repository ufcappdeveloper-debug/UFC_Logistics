import 'package:flutter/material.dart';

const Color swipeBtnBgColor = Color.fromRGBO(230, 72, 27, 1);
const Color boldTitleTextColors = Color.fromRGBO(41, 41, 41, 1);
const Color whiteTextColors = Color.fromRGBO(255, 255, 255, 1);
const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
const blackColor = Color(0xFF262626);
const Color orderDetailsBgColors = Color.fromRGBO(250, 250, 250, 1);
const Color borderColor = Color.fromRGBO(238, 238, 238, 1);
const Color inactiveTabbarBtnTextColors = Color.fromRGBO(193, 193, 193, 1);
const Color boldTextColors = Color.fromRGBO(0, 0, 0, 1);
const Color lightHeadingTextColors = Color.fromRGBO(208, 214, 220, 1);
const Color actionIconColor = Color.fromRGBO(15, 15, 15, 1);
const Color inactiveBarColor = Color.fromRGBO(251, 183, 164, 1);
const Color inactiveTextColor2 = Color.fromRGBO(208, 214, 220, 1);
const Color ratingStarColor = Color.fromRGBO(248, 231, 28, 1);
const Color customGreyTextColor = Color.fromRGBO(160, 160, 160, 1);
const Color inactiveBorderColor = Color.fromRGBO(213, 218, 224, 1);
const Color signinFieldColor = Color.fromRGBO(255, 255, 255, 0.1);
const littleDarkGrey = Color(0xFF494949);
const gainsboroColor = Color(0xffDEDEDE);
// Gray color shades
const greyColor = Color(0xFFF5F5F5);
const nobelColor = Color(0xFF999999);
const matterhornColor = Color(0xFF575757);
const silverColor = Color(0xFFC4C4C4);
const whisperColor = Color(0xFFEEEEEE);
const whisper1Color = Color(0xFFEAEAEA);
const suvaGreyColor = Color(0xFF929292);
const whiteSmokeColor = Color(0xFFF8F8F8);
const whiteMoreSmokeColor = Color(0xADD8D8D8);
const whiteSmoke1Color = Color(0xFFF1F1F1);
const buttonShadeColor = Color(0xFFFAFFFC);
const glacierGrayColor = Color(0xFFE3E3E3);
const littleLightGrey = Color(0xFFEEEEFF);
const veryBlackColor = Colors.black;
const babyBlueColor = Color(0xffEEF9FF);

///------------------ MY COLORS CLASS ---------------//
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.dividerColor,
    required this.iconButtonBackground,
    required this.unSelectedColor,
    required this.errorColor,
    required this.shadowColor,
    required this.littleContainerColor,
    required this.reallBlackColor,
    required this.taskShadowColor,
    required this.analysisColor,
    required this.highLightColor,
    required this.inactiveTabbarBtnTextColor,
    required this.lightHeadingTextColor,
    required this.orderDetailsBgColor,
    required this.boldTitleTextColor,
  });
  final Color primaryColor;
  final Color secondaryColor;
  final Color dividerColor;
  final Color iconButtonBackground;
  final Color unSelectedColor;
  final Color errorColor;
  final Color shadowColor;
  final Color littleContainerColor;
  final Color reallBlackColor;
  final Color taskShadowColor;
  final Color analysisColor;
  final Color highLightColor;
  final Color inactiveTabbarBtnTextColor;
  final Color lightHeadingTextColor;
  final Color orderDetailsBgColor;
  final Color boldTitleTextColor;
  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? dividerColor,
    Color? iconButtonBackground,
    Color? unSelectedColor,
    Color? errorColor,
    Color? shadowColor,
    Color? littleContainerColor,
    Color? reallBlackColor,
    Color? taskShadowColor,
    Color? analysisColor,
  }) {
    return AppColors(
      boldTitleTextColor: boldTitleTextColor,
      orderDetailsBgColor: orderDetailsBgColor,
      lightHeadingTextColor: lightHeadingTextColor,
      inactiveTabbarBtnTextColor: inactiveTabbarBtnTextColor,
      highLightColor: highLightColor,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      dividerColor: dividerColor ?? this.dividerColor,
      iconButtonBackground: iconButtonBackground ?? this.iconButtonBackground,
      unSelectedColor: unSelectedColor ?? this.unSelectedColor,
      errorColor: errorColor ?? this.errorColor,
      shadowColor: shadowColor ?? this.shadowColor,
      littleContainerColor: littleContainerColor ?? this.littleContainerColor,
      reallBlackColor: reallBlackColor ?? this.reallBlackColor,
      taskShadowColor: taskShadowColor ?? this.taskShadowColor,
      analysisColor: analysisColor ?? this.analysisColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      boldTitleTextColor: boldTitleTextColor,
      orderDetailsBgColor: orderDetailsBgColor,
      lightHeadingTextColor: lightHeadingTextColor,
      inactiveTabbarBtnTextColor: inactiveTabbarBtnTextColor,
      highLightColor: highLightColor,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      iconButtonBackground:
          Color.lerp(iconButtonBackground, other.iconButtonBackground, t)!,
      unSelectedColor: Color.lerp(unSelectedColor, other.unSelectedColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      littleContainerColor:
          Color.lerp(littleContainerColor, other.littleContainerColor, t)!,
      reallBlackColor: Color.lerp(reallBlackColor, other.reallBlackColor, t)!,
      taskShadowColor: Color.lerp(taskShadowColor, other.taskShadowColor, t)!,
      analysisColor: Color.lerp(analysisColor, other.analysisColor, t)!,
    );
  }

  @override
  String toString() =>
      'AppColors(primaryColor:$primaryColor, secondaryColor:$secondaryColor)';

  static const light = AppColors(
    boldTitleTextColor: boldTitleTextColors,
    orderDetailsBgColor: orderDetailsBgColors,
    lightHeadingTextColor: lightHeadingTextColors,
    inactiveTabbarBtnTextColor: inactiveTabbarBtnTextColors,
    highLightColor: swipeBtnBgColor,
    primaryColor: blackColor,
    secondaryColor: whiteColor,
    dividerColor: gainsboroColor,
    iconButtonBackground: whiteSmokeColor,
    unSelectedColor: nobelColor,
    errorColor: Colors.red,
    shadowColor: gainsboroColor,
    littleContainerColor: greyColor,
    reallBlackColor: veryBlackColor,
    taskShadowColor: whiteMoreSmokeColor,
    analysisColor: Colors.blue,
  );

  static const dark = AppColors(
    boldTitleTextColor: whiteSmokeColor,
    orderDetailsBgColor: Colors.white10,
    lightHeadingTextColor: lightHeadingTextColors,
    inactiveTabbarBtnTextColor: inactiveTabbarBtnTextColors,
    highLightColor: swipeBtnBgColor,
    primaryColor: whiteColor,
    secondaryColor: blackColor,
    dividerColor: silverColor,
    iconButtonBackground: Colors.white24,
    unSelectedColor: Colors.white38,
    errorColor: Colors.red,
    shadowColor: Colors.white10,
    littleContainerColor: littleDarkGrey,
    reallBlackColor: whiteColor,
    taskShadowColor: Colors.black12,
    analysisColor: Colors.blue,
  );
}
