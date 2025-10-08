import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class ApiService {
  static const String baseUrl =
      'https://yourapi.com'; // Replace with your backend URL

  /// Login API
  /// Returns a map: { 'token': String, 'user': UserModel }
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userJson);

        return {'token': token, 'user': user};
      } else {
        throw Exception('Login failed with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Example: Future extension for other APIs
  /*
  static Future<UserModel> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load profile');
    }
  }
  */
}
