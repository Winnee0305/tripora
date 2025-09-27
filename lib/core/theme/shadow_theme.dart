import 'package:flutter/material.dart';

class ShadowTheme extends ThemeExtension<ShadowTheme> {
  final List<BoxShadow> buttonShadows;

  const ShadowTheme({required this.buttonShadows});

  @override
  ShadowTheme copyWith({List<BoxShadow>? buttonShadows}) {
    return ShadowTheme(buttonShadows: buttonShadows ?? this.buttonShadows);
  }

  @override
  ThemeExtension<ShadowTheme> lerp(
    ThemeExtension<ShadowTheme>? other,
    double t,
  ) {
    if (other is! ShadowTheme) return this;
    return ShadowTheme(buttonShadows: buttonShadows);
  }
}
