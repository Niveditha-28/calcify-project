import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feature_model.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000";
// or your LAN IP for device testing

  Future<List<FeatureModel>> fetchFeatures() async {
    final response = await http.get(Uri.parse('$baseUrl/home_page'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print("Raw API response: ${response.body}");
      return data.map((item) => FeatureModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load features");
    }
  }
}
