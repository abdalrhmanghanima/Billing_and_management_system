import 'package:billing_and_sales_management/data/clients/models/client_model.dart';

abstract interface class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients();

  Future<void> addClient(ClientModel client);

  Future<void> updateClient(ClientModel client);

  Future<void> deleteClient(String id);

  Future<int> getNextClientNumber();
}
