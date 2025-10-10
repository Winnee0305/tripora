import "package:flutter/material.dart";
import 'app_shadow_theme.dart';

class AppWidgetStyles {
  static BoxDecoration cardDecoration(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();
    return BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
