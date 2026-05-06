enum UserRole {
  user,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.user:
        return 'User';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
