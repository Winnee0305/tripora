import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Font weight extension for Manrope
extension ManropeFontWeight on FontWeight {
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

/// Global Manrope text styles
class AppTextStyles {
  static const _baseFont = 'Manrope';
  static const _fontFeatures = [FontFeature.enable('tnum')];

  static const TextStyle heading1 = TextStyle(
    fontFamily: _baseFont,
    fontSize: 24,
    fontWeight: ManropeFontWeight.semiBold,
    color: AppColors.darkPrimary,
    letterSpacing: 0.6,
    fontFeatures: _fontFeatures,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _baseFont,
    fontSize: 18,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.darkPrimary,
    letterSpacing: 0.5,
    fontFeatures: _fontFeatures,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _baseFont,
    fontSize: 16,
    fontWeight: ManropeFontWeight.semiBold,
    color: AppColors.darkPrimary,
    letterSpacing: 0.4,
    fontFeatures: _fontFeatures,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: _baseFont,
    fontSize: 14,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    fontFeatures: _fontFeatures,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _baseFont,
    fontSize: 12,
    fontWeight: ManropeFontWeight.regular,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    fontFeatures: _fontFeatures,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _baseFont,
    fontSize: 10,
    fontWeight: ManropeFontWeight.medium,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    fontFeatures: _fontFeatures,
  );
}

/// Quick text style modifiers
extension TextStyleX on TextStyle {
  /// Adjust opacity of text color
  TextStyle alpha(double value) =>
      copyWith(color: color?.withValues(alpha: value));

  /// Change weight dynamically
  TextStyle weight(FontWeight w) => copyWith(fontWeight: w);
}
