import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
