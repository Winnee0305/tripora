import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_style.dart';
import 'shadow_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.surfaceBright,
        secondary: AppColors.darkPrimary,
        onSecondary: AppColors.surfaceBright,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: Colors.red,
        onError: AppColors.surfaceBright,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.surfaceBright,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.subheading,
        bodyMedium: AppTextStyles.body,
        labelMedium: AppTextStyles.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surfaceBright,
          textStyle: AppTextStyles.subheading,
          elevation: 0, // 👈 disable built-in shadow
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),

      // 👇 Add custom theme extension here
      extensions: <ThemeExtension<dynamic>>[
        ShadowTheme(
          buttonShadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 10,
              offset: const Offset(0, 0.4),
            ),
          ],
        ),
      ],
    );
  }
}
