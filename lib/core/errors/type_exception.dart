import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class TypeExceptionCodes {
  const TypeExceptionCodes._();

  static const String companyRequired = 'company-required';
  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String inUse = 'in-use';
  static const String tooManyReferences = 'too-many-references';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class TypeException implements Exception {
  const TypeException(this.code);

  final String code;

  String get message {
    switch (code) {
      case TypeExceptionCodes.companyRequired:
        return AppTranslate.companyNameRequired.tr();
      case TypeExceptionCodes.nameRequired:
        return AppTranslate.typeNameRequired.tr();
      case TypeExceptionCodes.nameDuplicate:
        return AppTranslate.typeNameAlreadyExists.tr();
      case TypeExceptionCodes.notFound:
        return AppTranslate.typeNotFound.tr();
      case TypeExceptionCodes.inUse:
        return AppTranslate.typeInUse.tr();
      case TypeExceptionCodes.tooManyReferences:
        return AppTranslate.typeTooManyReferences.tr();
      case TypeExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
