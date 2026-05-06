import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emergency_response/data/enums/user_role.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserRole>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserRole> {
  AuthNotifier() : super(UserRole.user);

  void toggleRole() {
    state = state == UserRole.user ? UserRole.admin : UserRole.user;
  }

  void setRole(UserRole role) {
    state = role;
  }

  bool get isAdmin => state == UserRole.admin;
}
