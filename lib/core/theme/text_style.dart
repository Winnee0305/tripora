import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ManropeFontWeight on FontWeight {
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: ManropeFontWeight.semiBold,
    color: AppColors.darkPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.darkPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: ManropeFontWeight.semiBold,
    color: AppColors.darkPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 14,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.textPrimary,
  );
}
