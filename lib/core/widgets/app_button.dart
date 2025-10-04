// import 'package:flutter/material.dart';
// import 'package:tripora/core/theme/app_shadow_theme.dart';

// class AppButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final String text;
//   final IconData? icon;
//   final double? minWidth;
//   final double? minHeight;
//   final List<BoxShadow>? boxShadow;
//   final double? iconSize;
//   final TextStyle? textStyle;
//   final double? radius;
//   final bool iconPosition; // true: left, false: right

//   const AppButton({
//     super.key,
//     required this.onPressed,
//     required this.text,
//     this.minWidth,
//     this.minHeight,
//     this.icon,
//     this.boxShadow,
//     this.iconSize,
//     this.textStyle,
//     this.radius,
//     this.iconPosition = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final shadowTheme = Theme.of(context).extension<ShadowTheme>();

//     Widget iconWidget = Align(
//       alignment: Alignment.center,
//       child: Icon(icon, size: iconSize),
//     );

//     Widget textWidget = Align(
//       alignment: Alignment.center,
//       child: Text(text, style: textStyle),
//     );

//     List<Widget> rowChildren = iconPosition
//         ? [iconWidget, const SizedBox(width: 6), textWidget]
//         : [textWidget, const SizedBox(width: 6), iconWidget];

//     return DecoratedBox(
//       decoration: BoxDecoration(
//         boxShadow: boxShadow ?? shadowTheme?.buttonShadows ?? [],
//         borderRadius: BorderRadius.circular(radius ?? 8),
//       ),
//       child: SizedBox(
//         child: ElevatedButton(
//           onPressed: onPressed,
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.symmetric(
//               horizontal: (minWidth != null) ? 0 : 16,
//               vertical: (minHeight != null) ? 0 : 12,
//             ),
//             minimumSize: Size(minWidth ?? 0, minHeight ?? 0),
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(radius ?? 24),
//             ),
//           ),
//           child: icon != null
//               ? Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: rowChildren,
//                 )
//               : textWidget,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';

enum AppButtonVariant { primary, secondary, textOnly }

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
  final bool iconPosition; // true: left, false: right
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.minWidth,
    this.minHeight,
    this.iconSize,
    this.textStyle,
    this.radius,
    this.iconPosition = true,
    this.boxShadow,
    this.variant = AppButtonVariant.primary,
  });

  /// 🔹 Factory constructors for common button styles
  factory AppButton.details({Key? key, required VoidCallback onPressed}) {
    return AppButton(
      key: key,
      text: "Details",
      icon: CupertinoIcons.chevron_right,
      iconPosition: false,
      iconSize: 12,
      radius: 12,
      minHeight: 42,
      minWidth: 86,
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
    );
  }

  factory AppButton.primary({
    Key? key,
    required String text,
    IconData? icon,
    bool iconPosition = true,
    VoidCallback? onPressed,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      variant: AppButtonVariant.primary,
      onPressed: onPressed,
    );
  }

  factory AppButton.textOnly({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) {
    return AppButton(
      key: key,
      text: text,
      variant: AppButtonVariant.textOnly,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    // 🎨 Define styles by variant
    final Color backgroundColor;
    final Color textColor;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = colorScheme.surface;
        textColor = colorScheme.primary;
        break;
      case AppButtonVariant.textOnly:
        backgroundColor = Colors.transparent;
        textColor = colorScheme.primary;
        break;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: boxShadow ?? shadowTheme?.buttonShadows ?? [],
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          minimumSize: Size(minWidth ?? 0, minHeight ?? 42),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildContent(textColor),
        ),
      ),
    );
  }

  List<Widget> _buildContent(Color textColor) {
    final content = <Widget>[
      if (icon != null) Icon(icon, size: iconSize ?? 16, color: textColor),
      if (icon != null) const SizedBox(width: 6),
      Text(
        text,
        style:
            textStyle ??
            TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    ];
    return iconPosition ? content : content.reversed.toList();
  }
}
