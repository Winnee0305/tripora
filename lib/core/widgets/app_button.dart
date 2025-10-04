import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';

enum BackgroundVariant { filled, trans } // -- define the variants of background

enum TextStyleVariant { small, medium, large } // -- define text style variants

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? minWidth;
  final double? minHeight;
  final List<BoxShadow>? boxShadow;
  final double? iconSize;
  final double? radius;
  final bool iconPosition; // true: left, false: right
  final BackgroundVariant backgroundVariant;
  final TextStyleVariant textStyleVariant;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColorOverride;
  final Color? textColorOverride;
  final TextStyle? textStyleOverride;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.minWidth,
    this.minHeight,
    this.iconSize,
    this.radius,
    this.iconPosition = true,
    this.boxShadow,
    this.backgroundVariant = BackgroundVariant.filled,
    this.textStyleVariant = TextStyleVariant.medium,
    this.padding,
    this.backgroundColorOverride,
    this.textColorOverride,
    this.textStyleOverride,
  });

  /// 🔹 Factory constructors for common button styles
  factory AppButton.primary({
    // -- main button style
    Key? key,
    required String text,
    IconData? icon,
    bool iconPosition = true,
    VoidCallback? onPressed,
    double? radius,
    double? minWidth,
    double? minHeight,
    TextStyleVariant? textStyleVariant,
    BackgroundVariant? variant,
    List<BoxShadow>? boxShadow,
    double? iconSize,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      onPressed: onPressed,
      radius: radius ?? 24,
      minWidth: minWidth ?? 200,
      minHeight: minHeight ?? 42,
      textStyleVariant: textStyleVariant ?? TextStyleVariant.large,
      boxShadow: boxShadow,
      iconSize: iconSize,
      backgroundVariant: variant ?? BackgroundVariant.filled,
    );
  }

  factory AppButton.iconOnly({
    Key? key,
    required IconData icon,
    double? iconSize,
    VoidCallback? onPressed,
    BackgroundVariant? variant,
  }) {
    return AppButton(
      key: key,
      text: "",
      icon: icon,
      iconSize: iconSize ?? 24,
      backgroundVariant: variant ?? BackgroundVariant.trans,
      onPressed: onPressed,
      radius: 30,
      minHeight: 40,
      minWidth: 40,
      boxShadow: [],
      padding: EdgeInsets.zero,
    );
  }

  factory AppButton.textOnly({
    Key? key,
    required String text,
    TextStyleVariant? textStyleVariant,
    VoidCallback? onPressed,
    BackgroundVariant? variant,
    Color? backgroundColorOverride,
    Color? textColorOverride,
    TextStyle? textStyleOverride,
  }) {
    return AppButton(
      key: key,
      text: text,
      backgroundVariant: variant ?? BackgroundVariant.filled,
      onPressed: onPressed,
      textStyleVariant: textStyleVariant ?? TextStyleVariant.medium,
      radius: 30,
      minHeight: 14,
      minWidth: 14,
      boxShadow: [],
      padding: EdgeInsets.zero,
      backgroundColorOverride: backgroundColorOverride,
      textColorOverride: textColorOverride,
      textStyleOverride: textStyleOverride,
    );
  }

  factory AppButton.iconTextSmall({
    Key? key,
    required IconData icon,
    required String text,
    double? iconSize,
    VoidCallback? onPressed,
    BackgroundVariant? variant,
    double? minWidth,
    double? minHeight,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyleOverride,
    double? radius,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      iconSize: iconSize ?? 24,
      backgroundVariant: variant ?? BackgroundVariant.filled,
      onPressed: onPressed,
      radius: radius ?? 30,
      minHeight: minHeight ?? 40,
      minWidth: minWidth ?? 40,
      boxShadow: [],
      padding: EdgeInsets.zero,
      textStyleOverride: textStyleOverride,
    );
  }

  // factory AppButton.iconTextSmall({
  //   Key? key,
  //   required String text,
  //   TextStyleVariant? textStyleVariant,
  //   required IconData icon,
  //   bool? iconPosition,
  //   double? iconSize,
  //   double? radius,
  //   double? minWidth,
  //   double? minHeight,
  //   List<BoxShadow>? boxShadow,
  //   VoidCallback? onPressed,
  //   BackgroundVariant? variant,
  //   Color? backgroundColorOverride,
  //   Color? textColorOverride,
  //   TextStyle? textStyleOverride,
  // }) {
  //   return AppButton(
  //     key: key,
  //     text: text,
  //     icon: icon,
  //     iconPosition: iconPosition ?? true,
  //     backgroundVariant: variant ?? BackgroundVariant.trans,
  //     backgroundColorOverride: backgroundColorOverride,
  //     textColorOverride: textColorOverride,
  //     iconSize: iconSize ?? 16,
  //     onPressed: onPressed,
  //     radius: radius ?? 10,
  //     minWidth: minWidth ?? 74,
  //     minHeight: minHeight ?? 50,
  //     textStyleVariant: textStyleVariant ?? TextStyleVariant.medium,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    // 🎨 Define styles by variant
    final Color backgroundColor;
    final Color textColor;
    final TextStyle textStyle;

    final bool isSingleElement = text.isEmpty || icon == null;

    switch (backgroundVariant) {
      case BackgroundVariant.filled:
        backgroundColor = backgroundColorOverride ?? colorScheme.primary;
        textColor = textColorOverride ?? colorScheme.onPrimary;
        break;
      case BackgroundVariant.trans:
        backgroundColor =
            backgroundColorOverride ??
            colorScheme.primary.withValues(alpha: 0.2);
        textColor = textColorOverride ?? colorScheme.primary;
        break;
    }

    switch (textStyleVariant) {
      case TextStyleVariant.small:
        textStyle =
            textStyleOverride ??
            Theme.of(context).textTheme.labelMedium!.copyWith(
              fontWeight: ManropeFontWeight.light,
            );
        break;
      case TextStyleVariant.medium:
        textStyle =
            textStyleOverride ?? Theme.of(context).textTheme.bodyMedium!;
        break;
      case TextStyleVariant.large:
        textStyle =
            textStyleOverride ??
            Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            );
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
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          // ).copyWith(
          //   overlayColor: MaterialStateProperty.all(
          //     Colors.transparent,
          //   ), // 🚫 No press effect
          //   shadowColor: MaterialStateProperty.all(
          //     Colors.transparent,
          //   ), // 🚫 No
        ),
        child: isSingleElement
            ? (icon != null
                  ? Icon(icon, size: iconSize ?? 20, color: textColor)
                  : Text(text, style: textStyle.copyWith(color: textColor)))
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(textColor, textStyle),
              ),
      ),
    );
  }

  List<Widget> _buildContent(Color textColor, TextStyle textStyle) {
    final content = <Widget>[
      if (icon != null) Icon(icon, size: iconSize ?? 16, color: textColor),
      if (icon != null) const SizedBox(width: 6),
      Text(text, style: textStyle.copyWith(color: textColor)),
    ];
    return iconPosition ? content : content.reversed.toList();
  }
}
