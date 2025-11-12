import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getPoiDesc(String poiName, String location) async {
  final url = Uri.parse("http://192.168.0.123:8000/describe");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "preferences": {},
      "pois": [poiName],
      "location": location,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Itinerary: ${data['itinerary']}");
  } else {
    print("Request failed: ${response.statusCode}");
    print("Response: ${response.body}");
  }
}
