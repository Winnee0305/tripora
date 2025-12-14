import 'package:flutter/material.dart';
import 'package:tripora/core/repositories/chat_history_repository.dart';
import 'package:tripora/core/services/ai_chatbot_service.dart';
import 'package:tripora/features/chat/models/chat_message.dart';

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    this.messages = const [],
  });

  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    List<ChatMessage>? messages,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      messages: messages ?? this.messages,
    );
  }
}

class ChatViewModel extends ChangeNotifier {
  final AiChatbotService _chatRepository = AiChatbotService();
  final ChatHistoryRepository _historyRepository;

  // Current chat session
  late ChatSession _currentSession;

  // Chat history
  final List<ChatSession> _chatHistory = [];

  bool _isSidebarVisible = false;
  bool _isLoading = false;
  bool _isInitializing = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_currentSession.messages);
  List<ChatSession> get chatHistory => List.unmodifiable(_chatHistory);
  bool get hasMessages => _currentSession.messages.isNotEmpty;
  bool get isSidebarVisible => _isSidebarVisible;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get error => _error;

  final TextEditingController textController = TextEditingController();

  ChatViewModel(String? userId)
    : _historyRepository = ChatHistoryRepository(userId ?? 'anonymous') {
    _initializeViewModel();
  }

  /// Initialize the ViewModel by loading chat history from database
  Future<void> _initializeViewModel() async {
    _isInitializing = true;
    notifyListeners();

    try {
      final sessions = await _historyRepository.loadChatSessions();
      _chatHistory.addAll(sessions);
    } catch (e) {
      print('Error initializing chat history: $e');
      _error = 'Failed to load chat history';
    }

    _currentSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      messages: [],
    );

    _isInitializing = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text.trim(),
      sender: MessageSender.user,
    );
    _currentSession.messages.add(userMessage);

    // Save user message to database
    try {
      await _historyRepository.saveChatMessage(_currentSession.id, userMessage);
    } catch (e) {
      print('Error saving user message: $e');
    }

    notifyListeners();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Send to backend
      final result = await _chatRepository.sendChatQuery(text.trim());

      if (result['success'] == true) {
        // Add bot response
        final botReply = ChatMessage(
          text: result['response'] as String,
          sender: MessageSender.bot,
        );
        _currentSession.messages.add(botReply);

        // Save bot response to database
        try {
          await _historyRepository.saveChatMessage(
            _currentSession.id,
            botReply,
          );
        } catch (e) {
          print('Error saving bot message: $e');
        }

        // Update session title if first message and save to database
        if (_currentSession.messages.length == 2) {
          _currentSession = _currentSession.copyWith(
            title: text.trim().length > 30
                ? '${text.trim().substring(0, 30)}...'
                : text.trim(),
          );

          try {
            await _historyRepository.saveChatSession(_currentSession);
          } catch (e) {
            print('Error saving chat session: $e');
          }
        }
      } else {
        final errorMessage =
            result['error'] as String? ?? 'Unknown error occurred';
        _error = errorMessage;

        final errorReply = ChatMessage(
          text: 'Sorry, I encountered an error: $errorMessage',
          sender: MessageSender.bot,
        );
        _currentSession.messages.add(errorReply);

        // Save error message to database
        try {
          await _historyRepository.saveChatMessage(
            _currentSession.id,
            errorReply,
          );
        } catch (e) {
          print('Error saving error message: $e');
        }
      }
    } catch (e) {
      _error = 'Error: $e';
      final errorReply = ChatMessage(
        text: 'Sorry, I encountered an error communicating with the server.',
        sender: MessageSender.bot,
      );
      _currentSession.messages.add(errorReply);

      // Save error message to database
      try {
        await _historyRepository.saveChatMessage(
          _currentSession.id,
          errorReply,
        );
      } catch (e) {
        print('Error saving error message: $e');
      }
    }

    _isLoading = false;
    textController.clear();
    notifyListeners();
  }

  Future<void> startNewChat() async {
    // Save current session to history and database if it has messages
    if (_currentSession.messages.isNotEmpty) {
      _chatHistory.insert(0, _currentSession);
      try {
        await _historyRepository.saveChatSession(_currentSession);
      } catch (e) {
        print('Error saving chat session: $e');
      }
    }

    // Create new session
    _currentSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      messages: [],
    );

    _error = null;
    notifyListeners();
  }

  Future<void> loadChatSession(ChatSession session) async {
    // Save current session if it has messages
    if (_currentSession.messages.isNotEmpty) {
      _chatHistory.removeWhere((s) => s.id == _currentSession.id);
      _chatHistory.insert(0, _currentSession);

      try {
        await _historyRepository.saveChatSession(_currentSession);
      } catch (e) {
        print('Error saving current session: $e');
      }
    }

    // Load selected session with messages from database
    try {
      final loadedSession = await _historyRepository.loadChatSession(
        session.id,
      );
      if (loadedSession != null) {
        _currentSession = loadedSession;
      }
    } catch (e) {
      print('Error loading chat session: $e');
      _error = 'Failed to load chat session';
    }

    _isSidebarVisible = false;
    notifyListeners();
  }

  Future<void> deleteChatSession(ChatSession session) async {
    _chatHistory.removeWhere((s) => s.id == session.id);

    try {
      await _historyRepository.deleteChatSession(session.id);
    } catch (e) {
      print('Error deleting chat session: $e');
      _error = 'Failed to delete chat session';
      notifyListeners();
    }

    notifyListeners();
  }

  void toggleHistorySidebar() {
    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
