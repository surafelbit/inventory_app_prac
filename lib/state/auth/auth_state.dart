import '../../models/user_model.dart';
import '../../models/admin_model.dart';
import '../../models/branch_model.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final UserModel? user;
  final AdminModel? admin;
  final List<BranchModel> branches;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.branches = const [],
    this.token,
    this.user,
    this.admin,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
      branches: [],
      token: null,
      user: null,
      admin: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    UserModel? user,
    List<BranchModel>? branches,
    AdminModel? admin,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      branches: branches ?? this.branches,
      user: user ?? this.user,
      admin: admin ?? this.admin,
      error: error,
    );
  }
}
