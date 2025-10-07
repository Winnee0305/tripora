import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class DayCard extends StatelessWidget {
  final int day;
  final String dateLabel;
  final bool isSelected;

  const DayCard({
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(0),
        ),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(
                    0,
                    -8,
                  ), // 👈 negative Y = shadow above the box
                ),
              ]
            : [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(
                    0,
                    -8,
                  ), // 👈 negative Y = shadow above the box
                ),
              ],
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
