import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

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
        return AppTranslate.emailAddressNotValid.tr();
      case AuthExceptionCodes.invalidCredentials:
        return AppTranslate.incorrectEmailOrPassword.tr();
      case AuthExceptionCodes.userDisabled:
        return AppTranslate.accountDisabled.tr();
      case AuthExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      case AuthExceptionCodes.tooManyRequests:
        return AppTranslate.tooManyAttempts.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
