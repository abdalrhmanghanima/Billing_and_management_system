class AuthExceptionCodes {
  const AuthExceptionCodes._();

  static const String invalidEmail = 'invalid-email';
  static const String invalidCredentials = 'invalid-credentials';
  static const String userDisabled = 'user-disabled';
  static const String networkRequestFailed = 'network-request-failed';
  static const String tooManyRequests = 'too-many-requests';
  static const String unknown = 'unknown';
}

class AuthException implements Exception {
  const AuthException(this.code);

  final String code;

  String get message {
    switch (code) {
      case AuthExceptionCodes.invalidEmail:
        return 'The email address is not valid.';
      case AuthExceptionCodes.invalidCredentials:
        return 'Incorrect email or password. Please try again.';
      case AuthExceptionCodes.userDisabled:
        return 'This account has been disabled.';
      case AuthExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      case AuthExceptionCodes.tooManyRequests:
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
