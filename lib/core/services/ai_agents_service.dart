import 'dart:convert';
import 'package:http/http.dart' as http;

// Future<String> getPoiDesc(String poiName, String location) async {
//   final url = Uri.parse("http://192.168.0.123:8000/getDescription");

//   final response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "preferences": {},
//       "pois": [poiName],
//       "location": location,
//     }),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     // Change this depending on your API response structure
//     return data ?? "No description available";
//   } else {
//     print("Request failed: ${response.statusCode}");
//     print("Response: ${response.body}");
//     return "Failed to fetch description";
//   }
// }

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
