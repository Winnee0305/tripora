import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_text_field2.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:tripora/features/chat/views/widgets/bubble_animated_background.dart';
import 'package:tripora/features/chat/views/widgets/chat_content.dart';
import 'package:tripora/features/chat/views/widgets/chat_page_header.dart';
import 'package:tripora/features/chat/views/widgets/empty_chat_screen.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userVm = context.read<UserViewModel>();
    final userId = userVm.user!.uid;

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(userId),
      child: const _ChatPage(),
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);

    // Show loading indicator while initializing
    if (vm.isInitializing) {
      return BubbleAnimatedBackground(
        baseColor: Theme.of(context).colorScheme.primary,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return BubbleAnimatedBackground(
      baseColor: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          left: false,
          right: false,
          child: Stack(
            children: [
              // Main chat area
              Column(
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
                  // Loading indicator when bot is generating message
                  if (vm.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Generating response',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                vm.error!,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AppTextField2(
                      hintText: "Ask anything related to travel...",
                      icon: CupertinoIcons.return_icon,
                      controller: vm.textController,
                      onSubmitted: vm.isLoading ? null : vm.sendMessage,
                      enabled: !vm.isLoading,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // Chat History Sidebar
              if (vm.isSidebarVisible)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: vm.toggleHistorySidebar,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: GestureDetector(
                            onTap:
                                () {}, // Prevent closing when tapping sidebar
                            child: _ChatHistorySidebar(
                              onClose: vm.toggleHistorySidebar,
                              chatHistory: vm.chatHistory,
                              onSelectSession: vm.loadChatSession,
                              onDeleteSession: vm.deleteChatSession,
                              onNewChat: vm.startNewChat,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatHistorySidebar extends StatelessWidget {
  final VoidCallback onClose;
  final List<ChatSession> chatHistory;
  final Function(ChatSession) onSelectSession;
  final Function(ChatSession) onDeleteSession;
  final VoidCallback onNewChat;

  const _ChatHistorySidebar({
    required this.onClose,
    required this.chatHistory,
    required this.onSelectSession,
    required this.onDeleteSession,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Chat History',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: onClose,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onNewChat();
                        onClose();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Divider(height: 1),
          // Chat history list
          Expanded(
            child: chatHistory.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No chat history yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4),
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final session = chatHistory[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          title: Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            _formatTime(session.createdAt),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 18,
                            ),
                            onPressed: () {
                              onDeleteSession(session);
                            },
                          ),
                          onTap: () {
                            onSelectSession(session);
                            onClose();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }
}
