import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  const AppTextField({
    super.key,
    this.obscureText = false,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        filled: true, // 👈 this tells Flutter to paint the background
        fillColor: AppColors.primary.withValues(alpha: 0.1),
        labelText: label,
        labelStyle: theme.textTheme.labelMedium,
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
