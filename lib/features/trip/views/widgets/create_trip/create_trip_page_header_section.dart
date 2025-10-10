import 'package:flutter/material.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';

class CreateTripPageHeaderSection extends StatelessWidget {
  const CreateTripPageHeaderSection({super.key});
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
                'Create New Trip',
                style: theme.textTheme.headlineSmall?.weight(
                  ManropeFontWeight.semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Opacity(
                opacity: 0,
                child: AppButton.iconOnly(
                  icon: CupertinoIcons.home,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  backgroundVariant: BackgroundVariant.primaryTrans,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
