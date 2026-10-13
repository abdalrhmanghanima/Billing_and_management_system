import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class InvoiceExceptionCodes {
  const InvoiceExceptionCodes._();

  static const String billDateRequired = 'bill-date-required';
  static const String clientRequired = 'client-required';
  static const String itemsEmpty = 'items-empty';
  static const String itemNameRequired = 'item-name-required';
  static const String quantityRequired = 'quantity-required';
  static const String quantityGreaterThanZero = 'quantity-greater-than-zero';
  static const String sellingPriceRequired = 'selling-price-required';
  static const String sellingPriceInvalid = 'selling-price-invalid';
  static const String discountInvalid = 'discount-invalid';
  static const String percentageDiscountInvalid = 'percentage-discount-invalid';
  static const String valueDiscountInvalid = 'value-discount-invalid';
  static const String paidUpInvalid = 'paid-up-invalid';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class InvoiceException implements Exception {
  const InvoiceException(this.code);

  final String code;

  String get message {
    switch (code) {
      case InvoiceExceptionCodes.billDateRequired:
        return AppTranslate.billDateRequired.tr();
      case InvoiceExceptionCodes.clientRequired:
        return AppTranslate.clientNameRequired.tr();
      case InvoiceExceptionCodes.itemsEmpty:
        return AppTranslate.noItemsAdded.tr();
      case InvoiceExceptionCodes.itemNameRequired:
        return AppTranslate.itemNameRequired.tr();
      case InvoiceExceptionCodes.quantityRequired:
        return AppTranslate.quantityRequired.tr();
      case InvoiceExceptionCodes.quantityGreaterThanZero:
        return AppTranslate.quantityGreaterThanZero.tr();
      case InvoiceExceptionCodes.sellingPriceRequired:
        return AppTranslate.sellingPriceRequired.tr();
      case InvoiceExceptionCodes.sellingPriceInvalid:
        return AppTranslate.sellingPriceInvalid.tr();
      case InvoiceExceptionCodes.discountInvalid:
        return AppTranslate.discountInvalid.tr();
      case InvoiceExceptionCodes.percentageDiscountInvalid:
        return AppTranslate.percentageDiscountInvalid.tr();
      case InvoiceExceptionCodes.valueDiscountInvalid:
        return AppTranslate.valueDiscountInvalid.tr();
      case InvoiceExceptionCodes.paidUpInvalid:
        return AppTranslate.paidUpInvalid.tr();
      case InvoiceExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
