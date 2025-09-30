import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? width;
  final List<BoxShadow>? boxShadow;
  final double? iconSize;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.icon,
    this.boxShadow,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: boxShadow ?? shadowTheme?.buttonShadows ?? [],
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        width: width,
        child: icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: iconSize),
                label: Text(text, style: textStyle),
              )
            : ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}
