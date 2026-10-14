import 'package:billing_and_sales_management/data/request_forms/models/request_form_model.dart';

abstract interface class RequestFormRemoteDataSource {
  Future<void> addRequestForm(RequestFormModel requestForm);

  Future<List<RequestFormModel>> getRequestFormsByClientId(String clientId);
}
