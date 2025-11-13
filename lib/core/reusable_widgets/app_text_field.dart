import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? text;
  final bool obscureText;
  final bool readOnly;
  final IconData? icon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool chooseButton;
  final bool isNumber;
  final bool isCurrency;
  final bool autofocus;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final InputDecoration? decoration;

  /// ---- Validation + Feedback ----
  final bool? isValid;
  final String? helperText;

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
    this.isCurrency = false,
    this.autofocus = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isValid,
    this.helperText,
    this.decoration,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.text ?? '');
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text only if the parent text changed
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text ?? '';
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      // Only dispose the controller if it was created internally
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ---- Determine suffix icon ----
    Widget? suffix;
    if (widget.chooseButton) {
      // “Choose” button mode
      suffix = Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: ManropeFontWeight.medium,
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
      );
    } else if (widget.isValid != null || widget.helperText != null) {
      suffix = Padding(
        padding: const EdgeInsets.only(right: 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: (widget.isValid == true)
              ? const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  key: ValueKey('valid'),
                  color: Color(0xFF2E7D32),
                  size: 18,
                )
              : (widget.isValid == false && widget.helperText != null)
              ? const Icon(
                  CupertinoIcons.exclamationmark_circle_fill,
                  key: ValueKey('error'),
                  color: Color(0xFFD32F2F),
                  size: 18,
                )
              : const SizedBox.shrink(key: ValueKey('none')),
        ),
      );
    }

    return TextField(
      controller: _controller,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      style: theme.textTheme.bodyLarge,
      keyboardType: widget.isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : widget.keyboardType,
      inputFormatters: widget.isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      decoration:
          widget.decoration ??
          InputDecoration(
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
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: theme.colorScheme.primary, size: 20)
                : null,
            prefixText: widget.isCurrency ? "RM " : null,
            labelText: widget.label,
            labelStyle: theme.textTheme.titleLarge
                ?.alpha(0.7)
                .weight(ManropeFontWeight.light),
            floatingLabelBehavior: (widget.text?.isNotEmpty ?? false)
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffix,
            helperText: (widget.isValid == true) ? null : widget.helperText,
            helperStyle: theme.textTheme.labelMedium?.copyWith(
              color: widget.helperText != null && widget.isValid == false
                  ? theme.colorScheme.error
                  : widget.isValid == true
                  ? const Color(0xFF2E7D32)
                  : theme.colorScheme.outline,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }
}
