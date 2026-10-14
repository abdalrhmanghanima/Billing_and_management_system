import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';
import 'package:billing_and_sales_management/domain/request_forms/repositories/request_form_repository.dart';

class GetRequestFormsByClientId {
  const GetRequestFormsByClientId(this.repository);

  final RequestFormRepository repository;

  Future<List<RequestForm>> call(String clientId) {
    return repository.getRequestFormsByClientId(clientId);
  }
}
