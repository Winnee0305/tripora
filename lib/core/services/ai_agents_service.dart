import 'dart:convert';
import 'package:http/http.dart' as http;

class AIAgentService {
  final String baseUrl;

  AIAgentService({this.baseUrl = "http://127.0.0.1:8000"});

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    _handleError(response);
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    _handleError(response);
    return jsonDecode(response.body);
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    throw Exception("API Error ${response.statusCode}: ${response.body}");
  }
}
