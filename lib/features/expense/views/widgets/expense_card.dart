import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailingText;
  final String? leadingTag;
  final IconData? leadingIcon;
  final String? trailingTextUnit;
  final Color? leadingColor;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    this.trailingTextUnit,
    this.leadingTag,
    this.leadingIcon,
    this.leadingColor,
  }) : assert(
         leadingTag != null || leadingIcon != null,
         'Either leadingTag or leadingIcon must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Left (icon/tag + title/subtitle)
          Expanded(
            child: Row(
              children: [
                leadingIcon != null
                    ? AppButton.iconOnly(
                        icon: leadingIcon!,
                        onPressed: () {},
                        backgroundVariant: BackgroundVariant.primaryTrans,
                      )
                    : AppButton.textOnly(
                        text: leadingTag ?? 'Day',
                        onPressed: () {},
                        backgroundVariant: BackgroundVariant.primaryTrans,
                        textStyleOverride: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: ManropeFontWeight.semiBold,
                        ),
                      ),
                const SizedBox(width: 16),

                // --- Text Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Trailing Text (Right Side)
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailingTextUnit ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1C2A39),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                " ${trailingText}",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: ManropeFontWeight.bold,
                  color: const Color(0xFF1C2A39),
                  letterSpacing: 0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
