import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class AppTextField2 extends StatelessWidget {
  /// Controller for the text input
  final TextEditingController? controller;

  /// Hint text shown when empty
  final String hintText;

  /// Called whenever the text changes
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (pressing enter/search)
  final ValueChanged<String>? onSubmitted;

  /// Called when the search icon is tapped
  final VoidCallback? onSearchPressed;

  /// Whether the search icon button is visible
  final bool showSearchIcon;

  final IconData icon;
  final FocusNode? focusNode;
  final bool enabled;

  const AppTextField2({
    this.focusNode,
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onSearchPressed,
    this.showSearchIcon = true,
    required this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5, // ✅ visual disabled state
        child: Container(
          padding: const EdgeInsets.only(left: 24),
          decoration: AppWidgetStyles.cardDecoration(
            context,
          ).copyWith(borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              /// Text Input
              Expanded(
                child: TextField(
                  enabled: enabled, // ✅ critical
                  focusNode: enabled ? focusNode : null,
                  controller: controller,
                  onChanged: enabled ? onChanged : null,
                  onSubmitted: enabled ? onSubmitted : null,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: ManropeFontWeight.light,
                    ),
                    border: InputBorder.none,
                  ),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: ManropeFontWeight.medium,
                  ),
                ),
              ),

              /// Search Icon (optional)
              if (showSearchIcon)
                CircleAvatar(
                  radius: 22,
                  backgroundColor: enabled
                      ? theme.colorScheme.primary
                      : theme.disabledColor, // ✅ disabled color
                  child: IconButton(
                    icon: Icon(icon, color: Colors.white, size: 18),
                    onPressed: enabled
                        ? (onSearchPressed ??
                              () {
                                if (onSubmitted != null) {
                                  final query = controller?.text ?? '';
                                  onSubmitted!(query);
                                }
                              })
                        : null, // ✅ disables tap
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
