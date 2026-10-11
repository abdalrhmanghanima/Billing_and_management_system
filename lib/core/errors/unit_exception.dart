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
        return 'UNIT NAME is Required';
      case UnitExceptionCodes.nameDuplicate:
        return 'UNIT NAME has already existed before';
      case UnitExceptionCodes.notFound:
        return 'This unit no longer exists. It may have been deleted already.';
      case UnitExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
