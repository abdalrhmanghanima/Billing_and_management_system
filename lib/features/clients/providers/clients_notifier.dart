import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/data/clients/providers/client_providers.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/clients/usecases/add_client.dart';
import 'package:billing_and_sales_management/domain/clients/usecases/get_clients.dart';
import 'package:billing_and_sales_management/domain/clients/usecases/get_next_client_number.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getClientsUseCaseProvider = Provider<GetClients>(
  (ref) => GetClients(ref.watch(clientRepositoryProvider)),
);

final addClientUseCaseProvider = Provider<AddClient>(
  (ref) => AddClient(ref.watch(clientRepositoryProvider)),
);

final getNextClientNumberUseCaseProvider = Provider<GetNextClientNumber>(
  (ref) => GetNextClientNumber(ref.watch(clientRepositoryProvider)),
);

class ClientsNotifier extends AsyncNotifier<List<Client>> {
  bool _isSaving = false;

  @override
  Future<List<Client>> build() {
    return ref.read(getClientsUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getClientsUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addClient({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref
          .read(addClientUseCaseProvider)
          .call(name: name, phone: phone, address: address);
    } on ClientException catch (error) {
      return error.code == ClientExceptionCodes.nameDuplicate
          ? SaveResult.duplicate
          : SaveResult.failure;
    } catch (_) {
      return SaveResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return SaveResult.success;
  }
}

final clientsProvider = AsyncNotifierProvider<ClientsNotifier, List<Client>>(
  ClientsNotifier.new,
);

final nextClientNumberProvider = FutureProvider<int>(
  (ref) => ref.watch(getNextClientNumberUseCaseProvider).call(),
);
