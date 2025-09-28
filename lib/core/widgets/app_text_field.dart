import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final IconData icon;

  const AppTextField({
    super.key,
    this.obscureText = false,
    required this.onChanged,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 14.0,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
          minHeight: 50,
        ),
        filled: true, // 👈 this tells Flutter to paint the background
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 20),
        labelText: label,
        labelStyle: theme.textTheme.titleLarge
            ?.alpha(0.4)
            .weight(ManropeFontWeight.light),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
