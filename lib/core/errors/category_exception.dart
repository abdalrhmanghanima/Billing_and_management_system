class CategoryExceptionCodes {
  const CategoryExceptionCodes._();

  static const String nameRequired = 'name-required';
  static const String nameDuplicate = 'name-duplicate';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class CategoryException implements Exception {
  const CategoryException(this.code);

  final String code;

  String get message {
    switch (code) {
      case CategoryExceptionCodes.nameRequired:
        return 'Category Name is Required';
      case CategoryExceptionCodes.nameDuplicate:
        return 'Category Name has already existed before';
      case CategoryExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
