import 'package:flutter/material.dart';

class AppColors {
  // Brand / Primary
  static const Color primary = Color(0xFFF8A05A); // #F8A05A
  static const Color darkPrimary = Color(0xFF022B3A); // #022B3A

  // Surfaces
  static const Color surface = Color(0xFFFAFCFB); // #FAFCFB (light cards / bg)
  static const Color surfaceBright = Colors.white; // #FFFFFF (pure white)

  // Text
  static const Color textPrimary = Color(0xFF5F6062); // #5F6062

  // Design Colors (non-const because of opacity)
  static final Color design1 = primary.withOpacity(0.8); // #F8A05A @80%
  static final Color design2 = const Color(0xFF1DB7C0).withOpacity(0.8);
  static final Color design3 = const Color(0xFFFD4F80).withOpacity(0.8);
  static final Color design4 = const Color(0xFF4240A5).withOpacity(0.8);
  static final Color design5 = const Color(0xFFA8C256).withOpacity(0.8);

  // Accent Colors
  static final Color accent1 = Colors.purple;
}
