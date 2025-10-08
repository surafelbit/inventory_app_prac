// state/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import './../../models/user_model.dart';
import './../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadToken();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      final result =
          await ApiService.login(email, password); // returns {token, user}
      final token = result['token'] as String;
      final user = result['user'] as UserModel;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('username', user.name);

      state = state.copyWith(
          isLoggedIn: true, token: token, user: user, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = AuthState();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final username = prefs.getString('username');

    if (token != null && username != null) {
      state = state.copyWith(
          isLoggedIn: true,
          token: token,
          user: UserModel(name: username, email: ''));
    }
  }
}
