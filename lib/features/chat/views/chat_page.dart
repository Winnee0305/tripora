import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_text_field2.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/chat/models/chat_message.dart';
import 'package:tripora/features/chat/views/widgets/bubble_animated_background.dart';
import 'package:tripora/features/chat/views/widgets/chat_content.dart';
import 'package:tripora/features/chat/views/widgets/chat_input_bar.dart';
import 'package:tripora/features/chat/views/widgets/chat_page_header.dart';
import 'package:tripora/features/chat/views/widgets/empty_chat_screen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: const _ChatPage(),
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);
    return BubbleAnimatedBackground(
      baseColor: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          left: false,
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ChatPageHeader(vm: vm),
              ),
              if (vm.hasMessages)
                Expanded(child: ChatContent(vm: vm))
              else
                Expanded(child: EmptyChatScreen(vm: vm)),
              if (vm.isSidebarVisible)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: _ChatHistorySidebar(
                        onClose: vm.toggleHistorySidebar,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppTextField2(
                  hintText: "Ask anything related to travel...",
                  icon: CupertinoIcons.return_icon,
                  controller: vm.textController,
                  onSubmitted: vm.sendMessage,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
