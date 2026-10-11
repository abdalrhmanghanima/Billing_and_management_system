import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';

class DeleteClient {
  const DeleteClient(this.repository);

  final ClientRepository repository;

  Future<void> call(String id) {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const ClientException(ClientExceptionCodes.notFound);
    }

    return repository.deleteClient(trimmedId);
  }
}
