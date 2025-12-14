import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for storing TAM (Technology Acceptance Model) responses
class TAMResponse {
  final String userId;
  final String appVersion;
  final String featureEvaluated;
  final List<int> puResponses; // Perceived Usefulness (6 questions)
  final List<int> peouResponses; // Perceived Ease of Use (6 questions)
  final DateTime completedAt;
  final String? documentId; // For Firestore reference

  TAMResponse({
    required this.userId,
    required this.appVersion,
    required this.featureEvaluated,
    required this.puResponses,
    required this.peouResponses,
    required this.completedAt,
    this.documentId,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'appVersion': appVersion,
      'featureEvaluated': featureEvaluated,
      'responses': {'PU': puResponses, 'PEOU': peouResponses},
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  /// Create from Firestore document
  factory TAMResponse.fromMap(Map<String, dynamic> data, String docId) {
    final responses = data['responses'] ?? {};
    return TAMResponse(
      userId: data['userId'] ?? '',
      appVersion: data['appVersion'] ?? '1.0.0',
      featureEvaluated: data['featureEvaluated'] ?? 'AI Itinerary Planner',
      puResponses: List<int>.from(responses['PU'] ?? []),
      peouResponses: List<int>.from(responses['PEOU'] ?? []),
      completedAt:
          (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      documentId: docId,
    );
  }

  /// Calculate mean scores
  double get meanPU => puResponses.isEmpty
      ? 0
      : puResponses.reduce((a, b) => a + b) / puResponses.length;
  double get meanPEOU => peouResponses.isEmpty
      ? 0
      : peouResponses.reduce((a, b) => a + b) / peouResponses.length;
}
