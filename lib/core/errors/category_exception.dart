import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryExceptionCodes {
  const CategoryExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class CategoryException implements Exception {
  const CategoryException(this.code);

  final String code;

  String get message {
    switch (code) {
      case CategoryExceptionCodes.nameRequired:
        return AppTranslate.categoryNameRequired.tr();
      case CategoryExceptionCodes.nameDuplicate:
        return AppTranslate.categoryNameAlreadyExists.tr();
      case CategoryExceptionCodes.notFound:
        return AppTranslate.categoryNotFound.tr();
      case CategoryExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
