import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';

abstract interface class RequestFormRepository {
  Future<void> addRequestForm(RequestForm requestForm);
}
