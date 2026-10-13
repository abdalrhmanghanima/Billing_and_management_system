import 'package:billing_and_sales_management/core/errors/request_form_exception.dart';
import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';
import 'package:billing_and_sales_management/domain/request_forms/repositories/request_form_repository.dart';

class AddRequestForm {
  const AddRequestForm(this.repository);

  final RequestFormRepository repository;

  static final RegExp _timeRegex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

  static int _minutesOf(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<void> call({
    required String employeeName,
    required String date,
    required String startTime,
    required String endTime,
  }) {
    final trimmedEmployeeName = employeeName.trim();
    final trimmedDate = date.trim();
    final trimmedStartTime = startTime.trim();
    final trimmedEndTime = endTime.trim();

    if (trimmedEmployeeName.isEmpty) {
      throw const RequestFormException(
        RequestFormExceptionCodes.employeeNameRequired,
      );
    }
    if (trimmedDate.isEmpty) {
      throw const RequestFormException(RequestFormExceptionCodes.dateRequired);
    }
    if (trimmedStartTime.isEmpty) {
      throw const RequestFormException(
        RequestFormExceptionCodes.startTimeRequired,
      );
    }
    if (trimmedEndTime.isEmpty) {
      throw const RequestFormException(
        RequestFormExceptionCodes.endTimeRequired,
      );
    }
    if (!_timeRegex.hasMatch(trimmedStartTime)) {
      throw const RequestFormException(
        RequestFormExceptionCodes.startTimeInvalid,
      );
    }
    if (!_timeRegex.hasMatch(trimmedEndTime)) {
      throw const RequestFormException(
        RequestFormExceptionCodes.endTimeInvalid,
      );
    }
    if (_minutesOf(trimmedEndTime) <= _minutesOf(trimmedStartTime)) {
      throw const RequestFormException(
        RequestFormExceptionCodes.endTimeNotAfterStartTime,
      );
    }

    return repository.addRequestForm(
      RequestForm(
        employeeName: trimmedEmployeeName,
        date: trimmedDate,
        startTime: trimmedStartTime,
        endTime: trimmedEndTime,
      ),
    );
  }
}
