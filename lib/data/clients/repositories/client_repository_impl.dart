import 'package:billing_and_sales_management/data/clients/datasources/remote/client_remote_data_source.dart';
import 'package:billing_and_sales_management/data/clients/models/client_model.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl(this._remoteDataSource);

  final ClientRemoteDataSource _remoteDataSource;

  @override
  Future<List<Client>> getClients() {
    return _remoteDataSource.getClients();
  }

  @override
  Future<void> addClient(Client client) {
    return _remoteDataSource.addClient(ClientModel.fromEntity(client));
  }

  @override
  Future<int> getNextClientNumber() {
    return _remoteDataSource.getNextClientNumber();
  }
}
