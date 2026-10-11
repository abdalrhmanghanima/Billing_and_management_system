import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/data/items/providers/item_providers.dart';
import 'package:billing_and_sales_management/data/types/providers/type_providers.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/domain/types/usecases/add_type.dart';
import 'package:billing_and_sales_management/domain/types/usecases/delete_type.dart';
import 'package:billing_and_sales_management/domain/types/usecases/get_types.dart';
import 'package:billing_and_sales_management/domain/types/usecases/update_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTypesUseCaseProvider = Provider<GetTypes>(
  (ref) => GetTypes(ref.watch(typeRepositoryProvider)),
);

final addTypeUseCaseProvider = Provider<AddType>(
  (ref) => AddType(ref.watch(typeRepositoryProvider)),
);

final updateTypeUseCaseProvider = Provider<UpdateType>(
  (ref) => UpdateType(ref.watch(typeRepositoryProvider)),
);

final deleteTypeUseCaseProvider = Provider<DeleteType>(
  (ref) => DeleteType(
    ref.watch(typeRepositoryProvider),
    ref.watch(itemRepositoryProvider),
  ),
);

class TypesNotifier extends AsyncNotifier<List<ItemType>> {
  bool _isSaving = false;

  @override
  Future<List<ItemType>> build() {
    return ref.read(getTypesUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getTypesUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addType({
    required String companyId,
    required String companyName,
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref
          .read(addTypeUseCaseProvider)
          .call(
            companyId: companyId,
            companyName: companyName,
            name: name,
            notes: notes,
          );
    } on TypeException catch (error) {
      return error.code == TypeExceptionCodes.nameDuplicate
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

  Future<SaveResult> updateType({
    required String id,
    required String companyId,
    required String companyName,
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref
          .read(updateTypeUseCaseProvider)
          .call(
            id: id,
            companyId: companyId,
            companyName: companyName,
            name: name,
            notes: notes,
          );
    } on TypeException catch (error) {
      return error.code == TypeExceptionCodes.nameDuplicate
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

  Future<DeleteResult> deleteType(String id) async {
    if (_isSaving) return DeleteResult.failure;

    _isSaving = true;
    try {
      await ref.read(deleteTypeUseCaseProvider).call(id);
    } on TypeException catch (error) {
      return error.code == TypeExceptionCodes.inUse
          ? DeleteResult.blocked
          : DeleteResult.failure;
    } catch (_) {
      return DeleteResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return DeleteResult.success;
  }
}

final typesProvider = AsyncNotifierProvider<TypesNotifier, List<ItemType>>(
  TypesNotifier.new,
);
