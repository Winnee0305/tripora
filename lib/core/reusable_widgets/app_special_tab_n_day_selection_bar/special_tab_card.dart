import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class SpecialTabCard extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Color color;

  const SpecialTabCard({
    super.key,
    required this.isSelected,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: AppWidgetStyles.cardDecoration(context).copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: isSelected ? color : theme.colorScheme.surface,
      ),

      clipBehavior: Clip.none,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondary,
              fontWeight: ManropeFontWeight.semiBold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
