import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

class LodgingCard extends StatelessWidget {
  const LodgingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Row(
        children: [
          AppButton.iconOnly(
            icon: Icons.hotel,
            onPressed: () {},
            iconSize: 18,
            minHeight: 30,
            minWidth: 30,
            backgroundColorOverride: AppColors.accent1.withValues(alpha: 0.1),
            textColorOverride: AppColors.accent1,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "AMES Hotel",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.weight(ManropeFontWeight.semiBold),
            ),
          ),
          const Text("CHECK IN", style: TextStyle(color: Colors.purple)),
        ],
      ),
    );
  }
}
