import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class UnitExceptionCodes {
  const UnitExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class UnitException implements Exception {
  const UnitException(this.code);

  final String code;

  String get message {
    switch (code) {
      case UnitExceptionCodes.nameRequired:
        return AppTranslate.unitNameRequired.tr();
      case UnitExceptionCodes.nameDuplicate:
        return AppTranslate.unitNameAlreadyExists.tr();
      case UnitExceptionCodes.notFound:
        return AppTranslate.unitNotFound.tr();
      case UnitExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
