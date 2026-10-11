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
        return 'COMPANY NAME is Required';
      case ItemExceptionCodes.typeRequired:
        return 'TYPE NAME is Required';
      case ItemExceptionCodes.nameRequired:
        return 'ITEM NAME is Required';
      case ItemExceptionCodes.nameDuplicate:
        return 'ITEM NAME has already existed before';
      case ItemExceptionCodes.notFound:
        return 'This item no longer exists. It may have been deleted already.';
      case ItemExceptionCodes.sellingPriceInvalid:
        return 'SELLING PRICE Must be Greater than or equal Zero';
      case ItemExceptionCodes.buyingPriceInvalid:
        return 'BUYING PRICE Must be Greater than or equal Zero';
      case ItemExceptionCodes.buyingPriceExceedsSelling:
        return 'BUYING PRICE Must be less than or equal SELLING PRICE';
      case ItemExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
