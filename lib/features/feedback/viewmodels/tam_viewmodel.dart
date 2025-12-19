import 'package:flutter/material.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/feedback/models/tam_response.dart';

class TAMViewModel extends ChangeNotifier {
  // TAM Question definitions
  static const List<String> puQuestions = [
    'Using Tripora would enable me to plan my trips more quickly.',
    'Using Tripora would improve the quality of my travel planning.',
    'Using Tripora would increase my productivity when planning trips.',
    'Using Tripora would enhance my effectiveness in planning travel activities.',
    'Using Tripora would make travel planning easier for me.',
    'I find Tripora useful for planning my trips.',
  ];

  static const List<String> peouQuestions = [
    'Learning to use Tripora would be easy for me.',
    'I find it easy to get Tripora to do what I want it to do.',
    'My interaction with Tripora is clear and understandable.',
    'I find Tripora to be clear and understandable.',
    'It would be easy for me to become skillful at using Tripora.',
    'I find Tripora easy to use.',
  ];

  final FirestoreService _firestoreService = FirestoreService();
  final String _appVersion = '1.0.0'; // Default version, no async loading

  // Form state
  List<int> _puResponses = List<int>.filled(6, 0);
  List<int> _peouResponses = List<int>.filled(6, 0);
  int _currentQuestion = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<int> get puResponses => _puResponses;
  List<int> get peouResponses => _peouResponses;
  int get currentQuestion => _currentQuestion;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Total questions
  static const int totalQuestions = 12; // 6 PU + 6 PEOU

  TAMViewModel() {} // Simple constructor, no async calls

  /// Get current question text
  String getCurrentQuestionText() {
    if (_currentQuestion < 6) {
      return puQuestions[_currentQuestion];
    } else {
      return peouQuestions[_currentQuestion - 6];
    }
  }

  /// Get current response value
  int getCurrentResponse() {
    if (_currentQuestion < 6) {
      return _puResponses[_currentQuestion];
    } else {
      return _peouResponses[_currentQuestion - 6];
    }
  }

  /// Set response for current question
  void setResponse(int value) {
    if (_currentQuestion < 6) {
      _puResponses[_currentQuestion] = value;
    } else {
      _peouResponses[_currentQuestion - 6] = value;
    }
    notifyListeners();
  }

  /// Check if current question is answered
  bool isCurrentQuestionAnswered() {
    return getCurrentResponse() != 0;
  }

  /// Move to next question
  void nextQuestion() {
    if (_currentQuestion < totalQuestions - 1) {
      _currentQuestion++;
      notifyListeners();
    }
  }

  /// Move to previous question
  void previousQuestion() {
    if (_currentQuestion > 0) {
      _currentQuestion--;
      notifyListeners();
    }
  }

  /// Reset form
  void reset() {
    _puResponses = List<int>.filled(6, 0);
    _peouResponses = List<int>.filled(6, 0);
    _currentQuestion = 0;
    _error = null;
    notifyListeners();
  }

  /// Submit TAM form
  Future<bool> submitTAM(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate all questions are answered
      for (int response in [..._puResponses, ..._peouResponses]) {
        if (response == 0) {
          _error = 'Please answer all questions before submitting.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      // Create TAM response
      final tamResponse = TAMResponse(
        userId: userId,
        appVersion: _appVersion,
        featureEvaluated: 'AI Itinerary Planner',
        puResponses: _puResponses,
        peouResponses: _peouResponses,
        completedAt: DateTime.now(),
      );

      // Store in Firestore
      await _firestoreService.saveTAMResponse(tamResponse.toMap());

      debugPrint('✅ TAM response submitted successfully');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to submit feedback: $e';
      debugPrint('❌ Failed to submit TAM: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
