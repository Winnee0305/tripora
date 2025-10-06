import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
      child: MasonryGridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          switch (index) {
            // ----- Notes
            case 0:
              return Container(
                height: 158,
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: theme.colorScheme.onPrimary,
                      size: 52,
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notes",
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.regular,
                          ),
                        ),
                        Text(
                          "5",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

            // ----- Expense
            case 1:
              return Container(
                height: 158,
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle,
                      color: theme.colorScheme.onPrimary,
                      size: 52,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Expense",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: ManropeFontWeight.regular,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "RM",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.light,
                          ),
                        ),
                        Text(
                          "300.00",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            case 2:
              return Container(
                height: 216,
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/icons/distance_white.png",
                      width: 88,
                      height: 88,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Itinerary",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: ManropeFontWeight.regular,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "9",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.semiBold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Activities",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: ManropeFontWeight.light,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            case 3:
              return Container(
                height: 101.5,
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Smart Packing List",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.regular,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.luggage_outlined,
                          color: theme.colorScheme.onPrimary,
                          size: 36,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "7",
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.semiBold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "/ 30",
                              style: theme.textTheme.headlineSmall!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: ManropeFontWeight.regular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            case 4:
              return Container(
                height: 101.5,
                decoration: AppWidgetStyles.cardDecoration(
                  context,
                ).copyWith(color: AppColors.design2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.paperclip,
                          color: theme.colorScheme.onPrimary,
                          size: 36,
                        ),
                        Text(
                          "5",
                          style: theme.textTheme.headlineLarge!
                              .weight(ManropeFontWeight.semiBold)
                              .colorize(theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Attachment",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: ManropeFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
