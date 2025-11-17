import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';
import 'package:tripora/core/theme/app_text_style.dart';

enum BackgroundVariant {
  primaryFilled,
  primaryTrans,
  secondaryFilled,
  secondaryTrans,
  danger,
}

enum TextStyleVariant { small, medium, large }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon; // original icon
  final Widget? iconWidget; // new widget-based icon
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
  final String? tooltipMessage;
  final MainAxisAlignment? mainAxisAlignment;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.minWidth,
    this.minHeight,
    this.iconSize,
    this.radius,
    this.iconPosition = true,
    this.boxShadow,
    this.backgroundVariant = BackgroundVariant.primaryFilled,
    this.textStyleVariant = TextStyleVariant.medium,
    this.padding,
    this.backgroundColorOverride,
    this.textColorOverride,
    this.textStyleOverride,
    this.tooltipMessage,
    this.mainAxisAlignment,
  });

  /// --- Factory constructors ---
  factory AppButton.primary({
    Key? key,
    required String text,
    IconData? icon,
    Widget? iconWidget,
    bool iconPosition = true,
    VoidCallback? onPressed,
    double? radius,
    double? minWidth,
    double? minHeight,
    TextStyleVariant? textStyleVariant,
    BackgroundVariant? backgroundVariant,
    List<BoxShadow>? boxShadow,
    double? iconSize,
    TextStyle? textStyleOverride,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      iconWidget: iconWidget,
      iconPosition: iconPosition,
      onPressed: onPressed,
      radius: radius ?? 24,
      minWidth: minWidth ?? 200,
      minHeight: minHeight ?? 42,
      textStyleVariant: textStyleVariant ?? TextStyleVariant.large,
      boxShadow: boxShadow,
      iconSize: iconSize,
      backgroundVariant: backgroundVariant ?? BackgroundVariant.primaryFilled,
      textStyleOverride: textStyleOverride,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  factory AppButton.iconOnly({
    Key? key,
    IconData? icon,
    Widget? iconWidget,
    double? iconSize,
    VoidCallback? onPressed,
    BackgroundVariant? backgroundVariant,
    Color? backgroundColorOverride,
    Color? textColorOverride,
    double? minWidth,
    double? minHeight,
    String? tooltipMessage,
    double? radius,
  }) {
    return AppButton(
      key: key,
      text: "",
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize ?? 24,
      backgroundVariant: backgroundVariant ?? BackgroundVariant.primaryFilled,
      onPressed: onPressed,
      radius: radius ?? 30,
      minHeight: minHeight ?? 40,
      minWidth: minWidth ?? 40,
      boxShadow: [],
      padding: EdgeInsets.zero,
      backgroundColorOverride: backgroundColorOverride,
      textColorOverride: textColorOverride,
      tooltipMessage: tooltipMessage,
    );
  }

  factory AppButton.textOnly({
    Key? key,
    required String text,
    TextStyleVariant? textStyleVariant,
    VoidCallback? onPressed,
    BackgroundVariant? backgroundVariant,
    Color? backgroundColorOverride,
    Color? textColorOverride,
    TextStyle? textStyleOverride,
    double? radius,
    double? minHeight,
    double? minWidth,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton(
      key: key,
      text: text,
      backgroundVariant: backgroundVariant ?? BackgroundVariant.primaryFilled,
      onPressed: onPressed,
      radius: radius ?? 30,
      minHeight: minHeight ?? 40,
      minWidth: minWidth ?? 40,
      boxShadow: [],
      padding: padding ?? EdgeInsets.zero,
      backgroundColorOverride: backgroundColorOverride,
      textStyleOverride: textStyleOverride,
      textColorOverride: textColorOverride,
      textStyleVariant: textStyleVariant ?? TextStyleVariant.medium,
    );
  }

  factory AppButton.iconTextSmall({
    Key? key,
    required IconData icon,
    Widget? iconWidget,
    required String text,
    double? iconSize,
    VoidCallback? onPressed,
    BackgroundVariant? backgroundVariant,
    double? minWidth,
    double? minHeight,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyleOverride,
    double? radius,
    bool? iconPosition,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize ?? 24,
      backgroundVariant: backgroundVariant ?? BackgroundVariant.primaryFilled,
      textStyleVariant: TextStyleVariant.small,
      onPressed: onPressed,
      radius: radius ?? 30,
      minHeight: minHeight ?? 40,
      minWidth: minWidth ?? 40,
      boxShadow: [],
      padding: EdgeInsets.zero,
      textStyleOverride: textStyleOverride,
      iconPosition: iconPosition ?? true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shadowTheme = Theme.of(context).extension<ShadowTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    final Color backgroundColor;
    final Color textColor;
    final TextStyle textStyle;

    final bool isSingleElement =
        text.isEmpty || (icon == null && iconWidget == null);

    // --- Background color ---
    switch (backgroundVariant) {
      case BackgroundVariant.primaryFilled:
        backgroundColor = backgroundColorOverride ?? colorScheme.primary;
        textColor = textColorOverride ?? colorScheme.onPrimary;
        break;
      case BackgroundVariant.primaryTrans:
        backgroundColor =
            backgroundColorOverride ?? colorScheme.primary.withOpacity(0.2);
        textColor = textColorOverride ?? colorScheme.primary;
        break;
      case BackgroundVariant.secondaryFilled:
        backgroundColor = backgroundColorOverride ?? colorScheme.onPrimary;
        textColor = textColorOverride ?? colorScheme.secondary;
        break;
      case BackgroundVariant.secondaryTrans:
        backgroundColor =
            backgroundColorOverride ?? colorScheme.surface.withOpacity(0.7);
        textColor = textColorOverride ?? colorScheme.secondary;
        break;
      case BackgroundVariant.danger:
        backgroundColor = backgroundColorOverride ?? Colors.red;
        textColor = textColorOverride ?? Colors.white;
        break;
    }

    // --- Text style ---
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
            textStyleOverride ??
            Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: ManropeFontWeight.regular,
            );
        break;
      case TextStyleVariant.large:
        textStyle =
            textStyleOverride ??
            Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            );
        break;
    }

    return Tooltip(
      message: tooltipMessage ?? '',
      waitDuration: const Duration(milliseconds: 500),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow:
              (backgroundVariant == BackgroundVariant.primaryTrans ||
                  backgroundVariant == BackgroundVariant.secondaryTrans)
              ? []
              : (boxShadow ?? shadowTheme?.buttonShadows ?? []),
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            minimumSize: Size(minWidth ?? 0, minHeight ?? 42),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
          ),
          child: isSingleElement
              ? (iconWidget ??
                    (icon != null
                        ? Icon(icon, size: iconSize ?? 20, color: textColor)
                        : Text(
                            text,
                            style: textStyle.copyWith(color: textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )))
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.center,
                  children: _buildContent(textColor, textStyle),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(Color textColor, TextStyle textStyle) {
    final content = <Widget>[];

    if (iconWidget != null) {
      content.add(iconWidget!);
    } else if (icon != null) {
      content.add(Icon(icon, size: iconSize ?? 16, color: textColor));
    }

    if (icon != null || iconWidget != null)
      content.add(const SizedBox(width: 6));

    content.add(
      Text(
        text,
        style: textStyle.copyWith(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return iconPosition ? content : content.reversed.toList();
  }
}
