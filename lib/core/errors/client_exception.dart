class ClientExceptionCodes {
  const ClientExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String phoneRequired = 'phone-required';
  static const String phoneInvalid = 'phone-invalid';
  static const String addressRequired = 'address-required';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class ClientException implements Exception {
  const ClientException(this.code);

  final String code;

  String get message {
    switch (code) {
      case ClientExceptionCodes.nameRequired:
        return 'CLIENT NAME is Required';
      case ClientExceptionCodes.nameDuplicate:
        return 'CLIENT NAME has already existed before';
      case ClientExceptionCodes.phoneRequired:
        return 'PHONE is Required';
      case ClientExceptionCodes.phoneInvalid:
        return 'PHONE must be just a 11 digit number';
      case ClientExceptionCodes.addressRequired:
        return 'Address is Required';
      case ClientExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
