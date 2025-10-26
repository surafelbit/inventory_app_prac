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
        body: jsonEncode({'name': name, 'address': address, 'houseType': type}),
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

  static Future<List<Map<String, dynamic>>> fetchPermissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('$baseUrl/workers/permissions');
      final token = prefs.getString('token');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Cast each item to Map<String, dynamic>
        return data
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        throw Exception('Failed to fetch branch');
      }
    } catch (error) {
      throw Exception('Error fetching branch: $error');
    }
  }

  static Future<Map<String, dynamic>> addWorkers(
      String name,
      String phone,
      String password,
      String userType,
      List<String> branchId,
      List<String> permissions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('$baseUrl/workers');
      final token = prefs.getString('token');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // 🔒 send JWT to backend
          },
          body: jsonEncode({
            'name': name,
            'phone': phone,
            'password': password,
            'userType': userType,
            'branchIds': branchId,
            'permissions': permissions.isNotEmpty ? permissions : null
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed To Add The Worker');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  static Future<List<dynamic>> fetchBranch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('$baseUrl/branches');
      final token = prefs.getString('token');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ jsonDecode returns a List<dynamic>
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch branch');
      }
    } catch (error) {
      throw Exception('Error fetching branch: $error');
    }
  }

  static Future<List<dynamic>> fetchWorker() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('$baseUrl/workers');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ jsonDecode returns a List<dynamic>
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch branch');
      }
    } catch (error) {
      throw Exception('Error fetching branch: $error');
    }
  }

  static Future<Map<String, dynamic>> getInfoAboutMe(String userID) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('this is the apiservices user id received');
      print(token);
      print(userID);
      final url = Uri.parse('$baseUrl/workers/getme?userid=$userID');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ jsonDecode returns a List<dynamic>
        print('this is the thing yo');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch branch');
      }
    } catch (error) {
      print(error);
      throw Exception('Error fetching branch: $error');
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
