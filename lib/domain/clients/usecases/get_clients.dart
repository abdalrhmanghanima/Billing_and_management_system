import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';

class GetClients {
  const GetClients(this.repository);

  final ClientRepository repository;

  Future<List<Client>> call() {
    return repository.getClients();
  }
}
