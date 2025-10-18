import 'package:flutter/material.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';

class ChatInputBar extends StatelessWidget {
  final ChatViewModel vm;
  const ChatInputBar({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: vm.textController,
              decoration: InputDecoration(
                hintText: 'Ask anything related to travel...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: vm.sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.orange),
            onPressed: () => vm.sendMessage(vm.textController.text),
          ),
        ],
      ),
    );
  }
}
