import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hanzi_trainer/configs/constants.dart';

final appTheme = ThemeData(
  primaryColor: kRed,
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    ),
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 58,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    color: kRed,
  ),
  scaffoldBackgroundColor: kYellow,
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kCircularBorderRadius),
    ),
    backgroundColor: kRed,
    contentTextStyle: TextStyle(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontSize: 20,
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontSize: 20,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCircularBorderRadius),
        side: BorderSide(color: Colors.white),
      ),
      backgroundColor: kYellow,
      textStyle: TextStyle(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        color: Colors.white,
        fontSize: 15,
      ),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: kRed,
    linearTrackColor: Colors.grey,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(kRed),
  ),
  listTileTheme: ListTileThemeData(
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
);
