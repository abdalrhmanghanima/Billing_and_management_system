import 'package:billing_and_sales_management/domain/clients/entities/client.dart';

abstract interface class ClientRepository {
  Future<List<Client>> getClients();

  Future<void> addClient(Client client);

  Future<int> getNextClientNumber();
}
