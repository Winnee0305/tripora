import 'package:flutter/material.dart';
import 'package:tripora/features/chat/models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isSidebarVisible = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get hasMessages => _messages.isNotEmpty;
  bool get isSidebarVisible => _isSidebarVisible;

  final TextEditingController textController = TextEditingController();

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      sender: MessageSender.user,
    );
    _messages.add(userMessage);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 700), () {
      final botReply = ChatMessage(
        text: _generateBotResponse(text),
        sender: MessageSender.bot,
      );
      _messages.add(botReply);
      notifyListeners();
    });

    textController.clear();
  }

  void startNewChat() {
    _messages.clear();
    notifyListeners();
  }

  void toggleHistorySidebar() {
    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }

  String _generateBotResponse(String input) {
    if (input.toLowerCase().contains('melaka')) {
      return '''
Here are some must-visit attractions in Melaka:
🏰 *A Famosa*: Explore this 16th-century fortress.
🏛️ *Stadthuys*: Visit the Dutch square.
🛍️ *Jonker Street*: Famous night market.
🍜 *Local Food*: Chicken Rice Balls, Nyonya Laksa, Cendol.
📍 *Hidden Gems*: Kampung Morten, Submarine Museum, Melaka Straits Mosque.
''';
    }
    return "I'm here to help! Ask me about places, food, or hidden gems in Malaysia 🇲🇾";
  }
}
