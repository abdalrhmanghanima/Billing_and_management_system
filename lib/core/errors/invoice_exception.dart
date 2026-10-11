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
        return 'BILL DATE is Required';
      case InvoiceExceptionCodes.clientRequired:
        return 'CLIENT NAME is Required';
      case InvoiceExceptionCodes.itemsEmpty:
        return 'No Items Added';
      case InvoiceExceptionCodes.itemNameRequired:
        return 'ITEM NAME is Required';
      case InvoiceExceptionCodes.quantityRequired:
        return 'Quantity is Required';
      case InvoiceExceptionCodes.quantityGreaterThanZero:
        return 'Quantity Must be Greater than Zero';
      case InvoiceExceptionCodes.sellingPriceRequired:
        return 'Selling Price is Required';
      case InvoiceExceptionCodes.sellingPriceInvalid:
        return 'SELLING PRICE Must be Greater than or equal Zero';
      case InvoiceExceptionCodes.discountInvalid:
        return 'Discount Must be Greater than or equal Zero';
      case InvoiceExceptionCodes.percentageDiscountInvalid:
        return 'Percentage discount Must be Greater than or equal Zero';
      case InvoiceExceptionCodes.valueDiscountInvalid:
        return 'Value discount Must be Greater than or equal Zero';
      case InvoiceExceptionCodes.paidUpInvalid:
        return 'Paid Up Must be Greater than or equal Zero';
      case InvoiceExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
