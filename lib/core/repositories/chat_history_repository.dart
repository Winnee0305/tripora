import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/features/chat/models/chat_message.dart';
import 'package:tripora/features/chat/viewmodels/chat_viewmodel.dart';

class ChatHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId; // User ID for multi-user support

  ChatHistoryRepository(this._userId);

  // Collection paths
  String get _chatSessionsCollection => 'users/$_userId/chat_sessions';
  String get _chatMessagesSubcollection => 'messages';

  /// Save a chat session to Firestore
  Future<void> saveChatSession(ChatSession session) async {
    try {
      await _firestore.collection(_chatSessionsCollection).doc(session.id).set({
        'id': session.id,
        'title': session.title,
        'createdAt': Timestamp.fromDate(session.createdAt),
        'updatedAt': Timestamp.now(),
        'messageCount': session.messages.length,
      });
    } catch (e) {
      print('Error saving chat session: $e');
      rethrow;
    }
  }

  /// Save a chat message to Firestore
  Future<void> saveChatMessage(String sessionId, ChatMessage message) async {
    try {
      await _firestore
          .collection(_chatSessionsCollection)
          .doc(sessionId)
          .collection(_chatMessagesSubcollection)
          .add({
            'text': message.text,
            'sender': message.sender == MessageSender.user ? 'user' : 'bot',
            'timestamp': Timestamp.fromDate(message.timestamp),
          });
    } catch (e) {
      print('Error saving chat message: $e');
      rethrow;
    }
  }

  /// Load all chat sessions for the user
  Future<List<ChatSession>> loadChatSessions() async {
    try {
      final snapshot = await _firestore
          .collection(_chatSessionsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => ChatSession(
              id: doc['id'] as String,
              title: doc['title'] as String,
              createdAt: (doc['createdAt'] as Timestamp).toDate(),
              messages: [], // Messages loaded separately
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading chat sessions: $e');
      return [];
    }
  }

  /// Load messages for a specific chat session
  Future<List<ChatMessage>> loadChatMessages(String sessionId) async {
    try {
      final snapshot = await _firestore
          .collection(_chatSessionsCollection)
          .doc(sessionId)
          .collection(_chatMessagesSubcollection)
          .orderBy('timestamp', descending: false)
          .get();

      return snapshot.docs
          .map(
            (doc) => ChatMessage(
              text: doc['text'] as String,
              sender: doc['sender'] == 'user'
                  ? MessageSender.user
                  : MessageSender.bot,
              timestamp: (doc['timestamp'] as Timestamp).toDate(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading chat messages: $e');
      return [];
    }
  }

  /// Load a specific chat session with all its messages
  Future<ChatSession?> loadChatSession(String sessionId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_chatSessionsCollection)
          .doc(sessionId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data()!;
      final messages = await loadChatMessages(sessionId);

      return ChatSession(
        id: data['id'] as String,
        title: data['title'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        messages: messages,
      );
    } catch (e) {
      print('Error loading chat session with messages: $e');
      return null;
    }
  }

  /// Update chat session (e.g., title change)
  Future<void> updateChatSession(ChatSession session) async {
    try {
      await _firestore
          .collection(_chatSessionsCollection)
          .doc(session.id)
          .update({'title': session.title, 'updatedAt': Timestamp.now()});
    } catch (e) {
      print('Error updating chat session: $e');
      rethrow;
    }
  }

  /// Delete a chat session and all its messages
  Future<void> deleteChatSession(String sessionId) async {
    try {
      // Delete all messages in the session
      final messagesSnapshot = await _firestore
          .collection(_chatSessionsCollection)
          .doc(sessionId)
          .collection(_chatMessagesSubcollection)
          .get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the session document
      await _firestore
          .collection(_chatSessionsCollection)
          .doc(sessionId)
          .delete();
    } catch (e) {
      print('Error deleting chat session: $e');
      rethrow;
    }
  }

  /// Clear all chat data for the user
  Future<void> clearAllChats() async {
    try {
      final sessionsSnapshot = await _firestore
          .collection(_chatSessionsCollection)
          .get();

      for (final sessionDoc in sessionsSnapshot.docs) {
        await deleteChatSession(sessionDoc.id);
      }
    } catch (e) {
      print('Error clearing all chats: $e');
      rethrow;
    }
  }

  /// Stream of chat sessions for real-time updates
  Stream<List<ChatSession>> streamChatSessions() {
    return _firestore
        .collection(_chatSessionsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatSession(
                  id: doc['id'] as String,
                  title: doc['title'] as String,
                  createdAt: (doc['createdAt'] as Timestamp).toDate(),
                  messages: [],
                ),
              )
              .toList(),
        );
  }

  /// Stream of messages for a specific session
  Stream<List<ChatMessage>> streamChatMessages(String sessionId) {
    return _firestore
        .collection(_chatSessionsCollection)
        .doc(sessionId)
        .collection(_chatMessagesSubcollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatMessage(
                  text: doc['text'] as String,
                  sender: doc['sender'] == 'user'
                      ? MessageSender.user
                      : MessageSender.bot,
                  timestamp: (doc['timestamp'] as Timestamp).toDate(),
                ),
              )
              .toList(),
        );
  }
}
