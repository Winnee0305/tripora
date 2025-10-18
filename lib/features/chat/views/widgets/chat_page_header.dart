import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';

class ChatPageHeader extends StatelessWidget {
  final ChatViewModel vm;
  const ChatPageHeader({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Ask Chatbot',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: ManropeFontWeight.semiBold,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.iconOnly(
              icon: LucideIcons.messageSquarePlus,
              onPressed: () {
                vm.startNewChat();
              },
              backgroundVariant: BackgroundVariant.primaryTrans,
            ),
            const SizedBox(width: 16),
            AppButton.iconOnly(
              icon: LucideIcons.panelRight,
              onPressed: () {
                vm.toggleHistorySidebar();
              },
              backgroundVariant: BackgroundVariant.primaryTrans,
            ),
          ],
        ),
      ],
    );
  }
}
