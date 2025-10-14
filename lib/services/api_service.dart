import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:3000'; // Replace with your backend URL

  /// Login API
  /// Returns a map: { 'token': String, 'user': UserModel }
  static Future<Map<String, dynamic>> login(
      String organizationPhone, String password) async {
    final url = Uri.parse('$baseUrl/workers/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'organizationPhone': organizationPhone, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(response.body);
        if (data['access_token'] != null && data['worker'] != null) {
          return data;
        } else {
          throw Exception('Invalid login response');
        }
      } else {
        throw Exception('Login failed with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  static Future<Map<String, dynamic>> loginAdmin(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['access_token'] != null && data['user'] != null) {
          return data;
        } else {
          throw Exception('Invalid login response');
        }
      } else {
        throw Exception('Login failed with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  static Future<Map<String, dynamic>> addBranch(
      String name, String address, String type) async {
    final url = Uri.parse('$baseUrl/branches');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 🔒 send JWT to backend
        },
        body: jsonEncode({'name': name, 'address': address, 'HouseType': type}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add branch');
      }
    } catch (error) {
      print(error);
      throw Exception(
          'Error creating branch: $error'); // <-- ensures a return or throw
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
