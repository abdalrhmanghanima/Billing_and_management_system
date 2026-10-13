import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientExceptionCodes {
  const ClientExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String phoneRequired = 'phone-required';
  static const String phoneInvalid = 'phone-invalid';
  static const String addressRequired = 'address-required';
  static const String notFound = 'not-found';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class ClientException implements Exception {
  const ClientException(this.code);

  final String code;

  String get message {
    switch (code) {
      case ClientExceptionCodes.nameRequired:
        return AppTranslate.clientNameRequired.tr();
      case ClientExceptionCodes.nameDuplicate:
        return AppTranslate.clientNameAlreadyExists.tr();
      case ClientExceptionCodes.phoneRequired:
        return AppTranslate.phoneRequired.tr();
      case ClientExceptionCodes.phoneInvalid:
        return AppTranslate.phoneInvalid.tr();
      case ClientExceptionCodes.addressRequired:
        return AppTranslate.addressRequired.tr();
      case ClientExceptionCodes.notFound:
        return AppTranslate.clientNotFound.tr();
      case ClientExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
