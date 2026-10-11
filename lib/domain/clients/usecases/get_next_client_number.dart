import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';

class GetNextClientNumber {
  const GetNextClientNumber(this.repository);

  final ClientRepository repository;

  Future<int> call() {
    return repository.getNextClientNumber();
  }
}
