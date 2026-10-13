import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemExceptionCodes {
  const ItemExceptionCodes._();

  static const String companyRequired = 'company-required';
  static const String typeRequired = 'type-required';
  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String sellingPriceInvalid = 'selling-price-invalid';
  static const String buyingPriceInvalid = 'buying-price-invalid';
  static const String buyingPriceExceedsSelling =
      'buying-price-exceeds-selling';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class ItemException implements Exception {
  const ItemException(this.code);

  final String code;

  String get message {
    switch (code) {
      case ItemExceptionCodes.companyRequired:
        return AppTranslate.companyNameRequired.tr();
      case ItemExceptionCodes.typeRequired:
        return AppTranslate.typeNameRequired.tr();
      case ItemExceptionCodes.nameRequired:
        return AppTranslate.itemNameRequired.tr();
      case ItemExceptionCodes.nameDuplicate:
        return AppTranslate.itemNameAlreadyExists.tr();
      case ItemExceptionCodes.notFound:
        return AppTranslate.itemNotFound.tr();
      case ItemExceptionCodes.sellingPriceInvalid:
        return AppTranslate.sellingPriceInvalid.tr();
      case ItemExceptionCodes.buyingPriceInvalid:
        return AppTranslate.buyingPriceInvalid.tr();
      case ItemExceptionCodes.buyingPriceExceedsSelling:
        return AppTranslate.buyingPriceExceedsSelling.tr();
      case ItemExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
