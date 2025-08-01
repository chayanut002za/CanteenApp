import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchAllRestaurants(String zone) async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/restaurants/$zone'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load restaurants');
  }
}
