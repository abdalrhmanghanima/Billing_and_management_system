import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';

class UpdateClient {
  const UpdateClient(this.repository);

  final ClientRepository repository;

  static final RegExp _phoneRegex = RegExp(r'^[0-9]{11}$');

  Future<void> call({
    required String id,
    required int number,
    required String name,
    required String phone,
    required String address,
  }) {
    if (id.trim().isEmpty) {
      throw const ClientException(ClientExceptionCodes.notFound);
    }

    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();
    final trimmedAddress = address.trim();

    if (trimmedName.isEmpty) {
      throw const ClientException(ClientExceptionCodes.nameRequired);
    }
    if (trimmedPhone.isEmpty) {
      throw const ClientException(ClientExceptionCodes.phoneRequired);
    }
    if (!_phoneRegex.hasMatch(trimmedPhone)) {
      throw const ClientException(ClientExceptionCodes.phoneInvalid);
    }
    if (trimmedAddress.isEmpty) {
      throw const ClientException(ClientExceptionCodes.addressRequired);
    }

    return repository.updateClient(
      Client(
        id: id.trim(),
        number: number,
        name: trimmedName,
        phone: trimmedPhone,
        address: trimmedAddress,
      ),
    );
  }
}
