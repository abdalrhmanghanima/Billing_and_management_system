import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/request_form_exception.dart';
import 'package:billing_and_sales_management/data/request_forms/providers/request_form_providers.dart';
import 'package:billing_and_sales_management/domain/request_forms/usecases/add_request_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addRequestFormUseCaseProvider = Provider<AddRequestForm>(
  (ref) => AddRequestForm(ref.watch(requestFormRepositoryProvider)),
);

class RequestFormsNotifier {
  RequestFormsNotifier(this._ref);

  final Ref _ref;

  bool _isSaving = false;

  Future<SaveResult> addRequestForm({
    required String employeeName,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await _ref
          .read(addRequestFormUseCaseProvider)
          .call(
            employeeName: employeeName,
            date: date,
            startTime: startTime,
            endTime: endTime,
          );
    } on RequestFormException catch (_) {
      return SaveResult.failure;
    } catch (_) {
      return SaveResult.failure;
    } finally {
      _isSaving = false;
    }

    return SaveResult.success;
  }
}

final requestFormsProvider = Provider<RequestFormsNotifier>(
  (ref) => RequestFormsNotifier(ref),
);
