import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';

class AppStickyHeader extends StatelessWidget {
  final String title;
  final bool showRightButton;
  final Icon leftButtonIcon;
  final Icon rightButtonIcon;
  final void Function()? onRightButtonPressed;
  final void Function()? onLeftButtonPressed;

  const AppStickyHeader({
    super.key,
    required this.title,
    this.showRightButton = true,
    this.leftButtonIcon = const Icon(CupertinoIcons.back),
    this.rightButtonIcon = const Icon(CupertinoIcons.home),
    this.onRightButtonPressed,
    this.onLeftButtonPressed,
  });
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
                icon: leftButtonIcon.icon!,
                onPressed: onLeftButtonPressed ?? () => Navigator.pop(context),
                backgroundVariant: BackgroundVariant.primaryTrans,
              ),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.weight(
                  ManropeFontWeight.semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Opacity(
                opacity: showRightButton ? 1 : 0,
                child: AppButton.iconOnly(
                  icon: rightButtonIcon.icon!,
                  onPressed:
                      onRightButtonPressed ??
                      () {
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
