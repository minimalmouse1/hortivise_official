import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const hintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.colorHint,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyStyleLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyStyleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: AppColors.colorWhite,
  );

  static const TextStyle bottomTabTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: AppColors.colorBlack,
  );

  static const TextStyle chipTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: AppColors.colorBlack,
  );
}

extension AppTextStyle on TextStyle {
  TextStyle changeColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle changeSize(double size) {
    return copyWith(fontSize: size);
  }

  TextStyle changeFontWeight(FontWeight weight) {
    return copyWith(fontWeight: weight);
  }

  TextStyle changeFontStyle(FontStyle style) {
    return copyWith(fontStyle: style);
  }

  TextStyle changeFontWeightDelta(int delta) {
    return apply(fontWeightDelta: delta);
  }

  TextStyle changeDecoration(TextDecoration decoration, Color color) {
    return copyWith(decoration: decoration, decorationColor: color);
  }
}
