import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationModel {
  final String? googlePlaceId;
  final String name;
  final String state;
  final double latitude;
  final double longitude;
  final int score;
  final int popularityScore;
  final double? googleRating;
  final String imageUrl;

  RecommendationModel({
    required this.googlePlaceId,
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.score,
    required this.popularityScore,
    required this.googleRating,
    this.imageUrl = '',
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      googlePlaceId: json['google_place_id'] as String?,
      name: json['name'] as String,
      state: json['state'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      score: (json['score'] as num).toInt(),
      popularityScore: (json['popularity_score'] as num).toInt(),
      googleRating: json['google_rating'] != null
          ? (json['google_rating'] as num).toDouble()
          : null,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'google_place_id': googlePlaceId,
    'name': name,
    'state': state,
    'lat': latitude,
    'lon': longitude,
    'score': score,
    'popularity_score': popularityScore,
    'google_rating': googleRating,
    'image_url': imageUrl,
  };
}

class UserBehavior {
  final List<String> collectedPlaceIds;
  final List<String> tripPlaceIds;
  final List<String> viewedPlaceIds;

  UserBehavior({
    this.collectedPlaceIds = const [],
    this.tripPlaceIds = const [],
    this.viewedPlaceIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'collected_place_ids': collectedPlaceIds,
    'trip_place_ids': tripPlaceIds,
    'viewed_place_ids': viewedPlaceIds,
  };

  bool get isEmpty =>
      collectedPlaceIds.isEmpty &&
      tripPlaceIds.isEmpty &&
      viewedPlaceIds.isEmpty;
}

class ForYouRecommenderService {
  final String baseUrl = 'http://127.0.0.1:8000';

  /// Get personalized 'For You' page recommendations
  ///
  /// [topN] - Number of recommendations to return (default: 5)
  /// [userBehavior] - Optional user behavior for personalization
  ///
  /// Returns a map containing:
  /// - success: bool indicating if request was successful
  /// - recommendations: List<RecommendationModel> of recommended POIs
  /// - isPersonalized: bool indicating if results are personalized
  /// - count: int number of recommendations returned
  /// - error: string error message if request failed
  Future<Map<String, dynamic>> getForYouRecommendations({
    int topN = 5,
    UserBehavior? userBehavior,
  }) async {
    try {
      final requestBody = {
        'top_n': topN,
        if (userBehavior != null && !userBehavior.isEmpty)
          'user_behavior': userBehavior.toJson(),
      };

      print('📤 ForYou Request: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/recommender/for-you'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('✅ ForYou Response: ${jsonEncode(data)}');

        final recommendations =
            (data['recommendations'] as List<dynamic>?)
                ?.map(
                  (item) => RecommendationModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [];

        return {
          'success': true,
          'recommendations': recommendations,
          'isPersonalized': data['is_personalized'] as bool? ?? false,
          'count': data['count'] as int? ?? recommendations.length,
        };
      } else {
        print('❌ ForYou Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'recommendations': [],
          'error': 'Failed to fetch recommendations: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('⚠️ ForYou Exception: $e');
      return {
        'success': false,
        'recommendations': [],
        'error': 'Error fetching recommendations: $e',
      };
    }
  }

  /// Get trending (non-personalized) recommendations
  Future<Map<String, dynamic>> getTrendingRecommendations({
    int topN = 5,
  }) async {
    return getForYouRecommendations(topN: topN);
  }
}
