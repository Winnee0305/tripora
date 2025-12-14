import 'package:http/http.dart' as http;
import 'dart:convert';

class AiChatbotService {
  final String baseUrl = 'http://127.0.0.1:8000';

  /// Send a chat query to the supervisor endpoint
  /// Returns a map with success status and response
  Future<Map<String, dynamic>> sendChatQuery(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/supervisor/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'response': data['response'] as String? ?? '',
          'trip_context': data['trip_context'] as Map<String, dynamic>?,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to get response: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error communicating with supervisor: $e',
      };
    }
  }
}
