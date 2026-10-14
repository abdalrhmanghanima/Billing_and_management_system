import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestFormExceptionCodes {
  const RequestFormExceptionCodes._();

  static const String clientRequired = 'client-required';
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
      case RequestFormExceptionCodes.clientRequired:
        return AppTranslate.clientNameRequired.tr();
      case RequestFormExceptionCodes.dateRequired:
        return AppTranslate.dateRequired.tr();
      case RequestFormExceptionCodes.startTimeRequired:
        return AppTranslate.startTimeRequired.tr();
      case RequestFormExceptionCodes.endTimeRequired:
        return AppTranslate.endTimeRequired.tr();
      case RequestFormExceptionCodes.startTimeInvalid:
        return AppTranslate.startTimeInvalid.tr();
      case RequestFormExceptionCodes.endTimeInvalid:
        return AppTranslate.endTimeInvalid.tr();
      case RequestFormExceptionCodes.endTimeNotAfterStartTime:
        return AppTranslate.endTimeMustBeAfterStartTime.tr();
      case RequestFormExceptionCodes.networkRequestFailed:
        return AppTranslate.networkError.tr();
      default:
        return AppTranslate.somethingWentWrong.tr();
    }
  }
}
