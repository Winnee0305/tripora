import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class NotesTabCard extends StatelessWidget {
  final bool isSelected;

  const NotesTabCard({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: AppWidgetStyles.cardDecoration(context).copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: isSelected ? AppColors.design2 : theme.colorScheme.surface,
      ),

      clipBehavior: Clip.none,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Notes",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondary,
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
