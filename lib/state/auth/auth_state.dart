import '../../models/user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final UserModel? user;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.token,
    this.user,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
      token: null,
      user: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error,
    );
  }
}
