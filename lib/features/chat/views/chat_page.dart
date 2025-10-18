import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/chat/models/chat_message.dart';
import 'package:tripora/features/chat/views/animated_gradient_background.dart';
import 'package:tripora/features/chat/views/bubble_animated_background.dart';
import 'package:tripora/features/chat/views/widgets/chat_page_header.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: const _ChatPageContent(),
    );
  }
}

class _ChatPageContent extends StatelessWidget {
  const _ChatPageContent();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);
    return BubbleAnimatedBackground(
      baseColor: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ChatPageHeader(),
                Expanded(child: _ChatMessagesView(vm: vm)),
              ],
            ),
          ),
        ),

        // backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: const Text(
        //     'Ask Chatbot',
        //     style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        //   ),
        //   centerTitle: false,
        //   actions: [
        //     IconButton(
        //       tooltip: 'New Chat',
        //       icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
        //       onPressed: () => vm.startNewChat(),
        //     ),
        //     IconButton(
        //       tooltip: 'Open Previous Chats',
        //       icon: const Icon(Icons.menu_open_rounded, color: Colors.orange),
        //       onPressed: () => vm.toggleHistorySidebar(),
        //     ),
        //   ],
        // ),
        // body: BubbleGradientBackground(
        //   baseColor: Theme.of(context).colorScheme.primary,

        // if (vm.isSidebarVisible)
        //   Positioned(
        //     top: 0,
        //     right: 0,
        //     bottom: 0,
        //     width: MediaQuery.of(context).size.width * 0.7,
        //     child: _ChatHistorySidebar(
        //       onClose: vm.toggleHistorySidebar,
        //     ),
        //   ),
      ),
    );
  }
}

class _ChatEmptyState extends StatelessWidget {
  final ChatViewModel vm;
  const _ChatEmptyState({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Text(
          'Hello Winnee',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'How can I help you today?',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Spacer(),
        Wrap(
          spacing: 8,
          children: [
            _QuickActionChip(
              label: 'Must-visit cultural attractions in Malaysia',
              onTap: () =>
                  vm.sendMessage('Must-visit cultural attractions in Malaysia'),
            ),
            _QuickActionChip(
              label: 'Plan a trip to Melaka',
              onTap: () => vm.sendMessage('Plan a trip to Melaka'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ChatInputBar(vm: vm),
      ],
    );
  }
}

class _ChatMessagesView extends StatelessWidget {
  final ChatViewModel vm;
  const _ChatMessagesView({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  decoration: BoxDecoration(
                    color: isUser ? Colors.orange[100] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              );
            },
          ),
        ),
        _ChatInputBar(vm: vm),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final ChatViewModel vm;
  const _ChatInputBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
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
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.orange[50],
        labelStyle: const TextStyle(color: Colors.orange),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _ChatHistorySidebar extends StatelessWidget {
  final VoidCallback onClose;
  const _ChatHistorySidebar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Previous Chats',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.orange),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: const [
                ListTile(title: Text('Trip to Melaka')),
                ListTile(title: Text('Cultural attractions in Malaysia')),
                ListTile(title: Text('Hidden gems in Penang')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
