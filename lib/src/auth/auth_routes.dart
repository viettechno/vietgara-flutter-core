/// The paths of the sign-in screens. Apps register the core's screens at
/// these paths, and the screens navigate between them.
abstract final class AuthRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
}
