import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class CompanyExceptionCodes {
  const CompanyExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String inUse = 'in-use';
  static const String tooManyReferences = 'too-many-references';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class CompanyException implements Exception {
  const CompanyException(this.code);

  final String code;

  String get message {
    switch (code) {
      case CompanyExceptionCodes.nameRequired:
        return AppTranslate.companyNameRequired.tr();
      case CompanyExceptionCodes.nameDuplicate:
        return AppTranslate.companyNameAlreadyExists.tr();
      case CompanyExceptionCodes.notFound:
        return AppTranslate.companyNotFound.tr();
      case CompanyExceptionCodes.inUse:
        return AppTranslate.companyInUse.tr();
      case CompanyExceptionCodes.tooManyReferences:
        return AppTranslate.companyTooManyReferences.tr();
      case CompanyExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
