import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../models/admin_model.dart';
import '../../services/api_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  Future<void> login(String phone, String password) async {
    try {
      state = state.copyWith(isLoading: true);

      final result = await ApiService.login(phone, password);
      final token = result['access_token'] as String;
      final user = UserModel.fromJson(result['worker']);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', user.toJsonString());

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        token: token,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loginAdmin(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await ApiService.loginAdmin(email, password);
      final token = result['access_token'] as String;
      final admin = AdminModel.fromJson(result['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', admin.toJsonString());
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        token: token,
        admin: admin,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    state = AuthState.initial();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userStr = prefs.getString('user');

    if (token != null && userStr != null) {
      final user = UserModel.fromJsonString(userStr);
      state = state.copyWith(
        isLoggedIn: true,
        token: token,
        user: user,
      );
    }
  }
}
