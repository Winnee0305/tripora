import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tripora/core/utils/constants.dart';

class AiDescService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  /// Fetches AI-generated description for a POI
  Future<String> fetchPoiDescription(
    String poiName,
    String location, {
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final prompt = _makePrompt(poiName, location, preferences);
      final response = await _callGeminiApi(prompt);
      return response;
    } catch (e) {
      if (kDebugMode) print('⚠️ Error fetching POI description: $e');
      return ''; // Return empty string on error
    }
  }

  /// Calls Gemini API to generate content
  Future<String> _callGeminiApi(String prompt) async {
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
          'topP': 0.95,
          'topK': 40,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_ONLY_HIGH',
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_ONLY_HIGH',
          },
        ],
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final parts = data['candidates']?[0]?['content']?['parts'] as List?;
        final text =
            parts?.map((p) => p['text']?.toString() ?? '').join(' ') ?? '';

        final finishReason = data['candidates']?[0]?['finishReason'];

        if (kDebugMode) {
          print('✅ POI description generated');
          print('📝 Finish reason: $finishReason');
          print('📄 Full text: $text');
        }

        if (text != null) {
          return text.toString();
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Gemini API error: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      }
      return '';
    } catch (e) {
      if (kDebugMode) print('❌ Failed to call Gemini API: $e');
      return '';
    }
  }

  /// Constructs the prompt for POI description generation
  String _makePrompt(
    String poiName,
    String location,
    Map<String, dynamic>? preferences,
  ) {
    String base =
        'You are a travel guide AI. Provide a concise and engaging description of '
        'the point of interest "$poiName" located in $location. '
        'Write a complete, well-formed description (2-3 full sentences, approximately 50-80 words) '
        'for this place to be displayed on a POI card. '
        'Include key highlights, historical facts, and unique features. '
        'IMPORTANT: The output MUST be complete sentences without any bullet points, lists, or truncation. '
        'Write the full description in one continuous paragraph.';

    if (preferences != null) {
      final interestType = preferences['interest_type'] ?? 'general';
      base +=
          ' Focus on aspects that appeal to users interested in $interestType.';
    }

    base += ' Make it sound natural, informative, and complete.';

    return base;
  }
}
