import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? text;
  final bool obscureText;
  final bool readOnly;
  final IconData? icon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool chooseButton;
  final bool isNumber;
  final bool autofocus;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final InputDecoration? decoration;

  const AppTextField({
    super.key,
    required this.label,
    this.text,
    this.icon,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.chooseButton = false,
    this.isNumber = false,
    this.autofocus = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveController =
        controller ??
        (readOnly ? TextEditingController(text: text ?? '') : null);

    return TextField(
      controller: effectiveController,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      obscureText: obscureText,
      style: theme.textTheme.bodyLarge,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
          minHeight: 50,
        ),
        filled: true,
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        prefixIcon: icon != null
            ? Icon(icon, color: theme.colorScheme.primary, size: 20)
            : null,
        prefixText: isNumber ? "RM " : null,
        labelText: label,
        labelStyle: theme.textTheme.titleLarge
            ?.alpha(0.4)
            .weight(ManropeFontWeight.light),
        floatingLabelBehavior: text?.isNotEmpty ?? false
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: chooseButton
            ? Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Choose",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
