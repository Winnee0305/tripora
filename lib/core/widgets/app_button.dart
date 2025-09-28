import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: shadowTheme?.buttonShadows ?? [],
          borderRadius: BorderRadius.circular(24),
        ),
        child: SizedBox(
          width: double.infinity,
          child: icon != null
              ? ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  label: Text(text),
                )
              : ElevatedButton(onPressed: onPressed, child: Text(text)),
        ),
      ),
    );
  }
}
