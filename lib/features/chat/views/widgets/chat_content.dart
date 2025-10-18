import "package:flutter/material.dart";
import "package:tripora/core/theme/app_widget_styles.dart";
import "package:tripora/features/chat/models/chat_message.dart";
import "package:tripora/features/chat/viewmodels/chat_viewmodel.dart";

class ChatContent extends StatelessWidget {
  final ChatViewModel vm;
  const ChatContent({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boxDecoration = AppWidgetStyles.cardDecoration(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            itemCount: vm.messages.length,
            itemBuilder: (context, index) {
              final message = vm.messages[index];
              final isUser = message.sender == MessageSender.user;
              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: isUser
                      ? boxDecoration.copyWith(
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        )
                      : boxDecoration,

                  child: Text(
                    message.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
