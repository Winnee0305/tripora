import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';

class PackingPageHeaderSection extends StatelessWidget {
  const PackingPageHeaderSection({
    super.key,
    required this.packedCount,
    required this.totalCount,
  });

  final int packedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ----- Top Bar -----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton.iconOnly(
                icon: CupertinoIcons.back,
                onPressed: () => Navigator.pop(context),
                backgroundVariant: BackgroundVariant.primaryTrans,
              ),
              Text(
                'Melaka 2 days family trip',
                style: theme.textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppButton.iconOnly(
                icon: CupertinoIcons.home,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                backgroundVariant: BackgroundVariant.primaryTrans,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ---- Smart Packing List Header ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Smart Packing List',
                style: theme.textTheme.headlineMedium?.weight(
                  ManropeFontWeight.bold,
                ),
              ),
              AppButton.textOnly(
                text: "$packedCount / $totalCount",
                onPressed: () {},
                backgroundVariant: BackgroundVariant.primaryFilled,
                radius: 10,
                minHeight: 38,
                minWidth: 80,
                textStyleOverride: theme.textTheme.titleLarge?.weight(
                  ManropeFontWeight.regular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
