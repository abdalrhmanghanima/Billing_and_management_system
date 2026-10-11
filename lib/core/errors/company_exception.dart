class CompanyExceptionCodes {
  const CompanyExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class CompanyException implements Exception {
  const CompanyException(this.code);

  final String code;

  String get message {
    switch (code) {
      case CompanyExceptionCodes.nameRequired:
        return 'COMPANY NAME is Required';
      case CompanyExceptionCodes.nameDuplicate:
        return 'COMPANY NAME has already existed before';
      case CompanyExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
