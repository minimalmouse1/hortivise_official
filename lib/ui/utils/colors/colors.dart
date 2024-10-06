import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color colorGreen = Color(0xFF087750);
  static const Color colorGreenLight = Color(0x1A087750);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBeige = Color(0xFFF7F0DE);
  static const Color colorBeigeDark = Color(0xFFF2E8CD);
  static const Color colorOrange = Color(0xFFFF7D00);
  static const Color colorGrayBg = Color(0xFFF1F1F1);
  static const Color colorBlack = Color(0xFF02010A);
  static const Color colorHint = Color(0xFF434343);
  static const Color colorGray = Color(0xFF515151);
  static const Color colorGrayLight = Color(0xFFE1E1E1);
  static const Color colorRed = Color(0xFFF62D2D);
  static const inputBorderColor = Color(0xFFE1E1E1);

  static MaterialColor appGreenMaterial = MaterialColor(
    0xFF087750,
    <int, Color>{
      50: colorGreen.withOpacity(0.050),
      100: colorGreen.withOpacity(0.100),
      200: colorGreen.withOpacity(.2),
      300: colorGreen.withOpacity(.3),
      400: colorGreen.withOpacity(.4),
      500: colorGreen,
      600: colorGreen.withOpacity(.6),
      700: colorGreen.withOpacity(.7),
      800: colorGreen.withOpacity(.8),
      900: colorGreen.withOpacity(.9),
    },
  );

  static MaterialColor appGrayMaterial = MaterialColor(
    0xFF515151,
    <int, Color>{
      50: colorGray.withOpacity(0.050),
      100: colorGray.withOpacity(0.100),
      200: colorGray.withOpacity(.2),
      300: colorGray.withOpacity(.3),
      400: colorGray.withOpacity(.4),
      500: colorGray,
      600: colorGray.withOpacity(.6),
      700: colorGray.withOpacity(.7),
      800: colorGray.withOpacity(.8),
      900: colorGray.withOpacity(.9),
    },
  );
}
