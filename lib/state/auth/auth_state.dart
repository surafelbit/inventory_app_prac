import '../../models/user_model.dart';

class AuthState {
  final bool isLoading; // true when logging in
  final bool isLoggedIn; // true if user is logged in
  final String? token; // auth token from backend
  final UserModel? user; // logged-in user object
  final String? error; // error message if login fails

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.token,
    this.user,
    this.error,
  });

  // Initial state before login
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
      token: null,
      user: null,
      error: null,
    );
  }

  // Create a copy with updated fields (used in notifier)
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
      error: error ?? this.error,
    );
  }
}
