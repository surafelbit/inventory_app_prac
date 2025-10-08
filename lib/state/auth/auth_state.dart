import './../../models/user_model.dart';

class AuthState {
  final bool isLoggedIn;
  final String? token;
  final UserModel? user;
  final bool loading;
  final String? error;
  AuthState(
      {this.isLoggedIn = false,
      this.token,
      this.user,
      this.loading = false,
      this.error});
  AuthState copyWith(
      {bool? isLoggedIn,
      String? token,
      UserModel? user,
      bool? loading,
      String? error}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
