class CompanyExceptionCodes {
  const CompanyExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String notFound = 'not-found';
  static const String inUse = 'in-use';
  static const String tooManyReferences = 'too-many-references';
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
      case CompanyExceptionCodes.notFound:
        return 'This company no longer exists. It may have been deleted already.';
      case CompanyExceptionCodes.inUse:
        return 'Cannot delete this company because it is used by existing types or items.';
      case CompanyExceptionCodes.tooManyReferences:
        return 'Cannot update this company because too many types or items are linked to it.';
      case CompanyExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
