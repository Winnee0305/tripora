import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';

class EmptyChatScreen extends StatelessWidget {
  final ChatViewModel vm;
  const EmptyChatScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: Text(
              'Hello Winnee',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: ManropeFontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'How can I help you today?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              AppButton.textOnly(
                text: 'Must-visit cultural attractions in Malaysia',
                onPressed: () => vm.sendMessage(
                  'Must-visit cultural attractions in Malaysia',
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                radius: 10,
                backgroundVariant: BackgroundVariant.primaryTrans,
                textStyleVariant: TextStyleVariant.medium,
              ),
              AppButton.textOnly(
                text: 'Plan a trip to Melaka',
                onPressed: () => vm.sendMessage('Plan a trip to Melaka'),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                radius: 10,
                backgroundVariant: BackgroundVariant.primaryTrans,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
