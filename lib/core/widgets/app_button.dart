import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? minWidth;
  final double? minHeight;
  final List<BoxShadow>? boxShadow;
  final double? iconSize;
  final TextStyle? textStyle;
  final double? radius;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.minWidth,
    this.minHeight,
    this.icon,
    this.boxShadow,
    this.iconSize,
    this.textStyle,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: boxShadow ?? shadowTheme?.buttonShadows ?? [],
        borderRadius: BorderRadius.circular(radius ?? 8),
      ),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(minWidth ?? 0, minHeight ?? 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 24),
            ),
          ),
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min, // shrink to fit content
                  children: [
                    Icon(icon, size: iconSize),
                    SizedBox(width: 4), // control spacing between icon & text
                    Text(text, style: textStyle),
                  ],
                )
              : Text(text, style: textStyle),
        ),
      ),
    );
  }
}
