import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ufc_delivery_app/extensions/app_colors.dart';

class AppTheme {
  AppTheme._();

  ///-------- LIGHT THEME---------//
  static final ThemeData light = ThemeData(
    extensions: const <ThemeExtension<AppColors>>[
      AppColors.light,
    ],
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteTextColors,
      elevation: 0,
      titleTextStyle: TextStyle(color: blackColor),
      iconTheme: IconThemeData(color: blackColor),
      actionsIconTheme: IconThemeData(color: blackColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteColor,
        systemNavigationBarColor: whiteColor,
        systemNavigationBarDividerColor: whiteColor,
        systemStatusBarContrastEnforced: false,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: whiteColor),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: whiteColor,
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: whiteColor),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,
  );

  /// ------- DARK THEME -------//
  static final ThemeData dark = ThemeData(
    extensions: const <ThemeExtension<AppColors>>[
      AppColors.dark,
    ],
    primaryTextTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    canvasColor: blackColor,
    colorScheme: ColorScheme.fromSeed(seedColor: blackColor),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: blackColor,
      surfaceTintColor: blackColor,
      shadowColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: blackColor),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: blackColor,
    scaffoldBackgroundColor: blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: blackColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: whiteColor,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: blackColor,
        systemNavigationBarColor: blackColor,
        systemNavigationBarDividerColor: blackColor,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: whiteColor),
      surfaceTintColor: whiteColor,
    ),
  );
}
