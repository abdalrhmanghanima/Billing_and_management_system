class RequestFormExceptionCodes {
  const RequestFormExceptionCodes._();

  static const String employeeNameRequired = 'employee-name-required';
  static const String dateRequired = 'date-required';
  static const String startTimeRequired = 'start-time-required';
  static const String endTimeRequired = 'end-time-required';
  static const String startTimeInvalid = 'start-time-invalid';
  static const String endTimeInvalid = 'end-time-invalid';
  static const String endTimeNotAfterStartTime =
      'end-time-not-after-start-time';
  static const String networkRequestFailed = 'network-request-failed';
  static const String unknown = 'unknown';
}

class RequestFormException implements Exception {
  const RequestFormException(this.code);

  final String code;

  String get message {
    switch (code) {
      case RequestFormExceptionCodes.employeeNameRequired:
        return 'Employee NAME is Required';
      case RequestFormExceptionCodes.dateRequired:
        return 'DATE is Required';
      case RequestFormExceptionCodes.startTimeRequired:
        return 'Start Time is Required';
      case RequestFormExceptionCodes.endTimeRequired:
        return 'End Time is Required';
      case RequestFormExceptionCodes.startTimeInvalid:
        return 'Start Time is Invalid';
      case RequestFormExceptionCodes.endTimeInvalid:
        return 'End Time is Invalid';
      case RequestFormExceptionCodes.endTimeNotAfterStartTime:
        return 'End Time must be greater than Start Time';
      case RequestFormExceptionCodes.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
