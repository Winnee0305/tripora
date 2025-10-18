import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

class ChatPageHeader extends StatelessWidget {
  const ChatPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ask Chatbot', style: Theme.of(context).textTheme.headlineMedium),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.iconOnly(
              icon: LucideIcons.messageSquarePlus,
              onPressed: () {},
              backgroundVariant: BackgroundVariant.primaryTrans,
            ),
            const SizedBox(width: 12),
            AppButton.iconOnly(
              icon: LucideIcons.panelRight,
              onPressed: () {},
              backgroundVariant: BackgroundVariant.primaryTrans,
            ),
          ],
        ),
      ],
    );
  }
}
