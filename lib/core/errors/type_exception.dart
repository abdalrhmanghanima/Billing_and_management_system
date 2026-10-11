class TypeExceptionCodes {
  const TypeExceptionCodes._();

  static const String companyRequired = 'company-required';
  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class TypeException implements Exception {
  const TypeException(this.code);

  final String code;

  String get message {
    switch (code) {
      case TypeExceptionCodes.companyRequired:
        return 'COMPANY NAME is Required';
      case TypeExceptionCodes.nameRequired:
        return 'TYPE NAME is Required';
      case TypeExceptionCodes.nameDuplicate:
        return 'TYPE NAME has already existed before';
      case TypeExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
