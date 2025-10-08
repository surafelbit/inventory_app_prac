import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  // Login function
  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true);

      final result = await ApiService.login(email, password);

      final token = result['token'] as String;
      final user = result['user'] as UserModel;

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        token: token,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Logout function
  void logout() {
    state = AuthState.initial();
  }
}
