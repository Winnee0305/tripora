import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class DayTabCard extends StatelessWidget {
  final int day;
  final String dateLabel;
  final bool isSelected;

  const DayTabCard({
    super.key,
    required this.day,
    required this.dateLabel,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppWidgetStyles.cardDecoration(context).copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
      ),

      clipBehavior: Clip.none,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Day $day",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondary,
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: ManropeFontWeight.light,
            ),
          ),
        ],
      ),
    );
  }
}
