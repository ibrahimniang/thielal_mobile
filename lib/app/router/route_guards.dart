class RouteGuards {
  static bool isAuthenticated = false;
  static String? currentRole;

  static bool canAccessUserArea() {
    return isAuthenticated;
  }

  static bool canAccessStaffArea() {
    return isAuthenticated &&
        (currentRole == 'staff' || currentRole == 'directeur');
  }

  static bool canAccessAdminArea() {
    return isAuthenticated && currentRole == 'admin';
  }
}
