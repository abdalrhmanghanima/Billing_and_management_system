import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/data/items/providers/item_providers.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/domain/items/usecases/add_item.dart';
import 'package:billing_and_sales_management/domain/items/usecases/delete_item.dart';
import 'package:billing_and_sales_management/domain/items/usecases/get_items.dart';
import 'package:billing_and_sales_management/domain/items/usecases/update_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getItemsUseCaseProvider = Provider<GetItems>(
  (ref) => GetItems(ref.watch(itemRepositoryProvider)),
);

final addItemUseCaseProvider = Provider<AddItem>(
  (ref) => AddItem(ref.watch(itemRepositoryProvider)),
);

final updateItemUseCaseProvider = Provider<UpdateItem>(
  (ref) => UpdateItem(ref.watch(itemRepositoryProvider)),
);

final deleteItemUseCaseProvider = Provider<DeleteItem>(
  (ref) => DeleteItem(ref.watch(itemRepositoryProvider)),
);

class ItemsNotifier extends AsyncNotifier<List<Item>> {
  bool _isSaving = false;

  @override
  Future<List<Item>> build() {
    return ref.read(getItemsUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getItemsUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addItem({
    required String companyId,
    required String companyName,
    required String typeId,
    required String typeName,
    required String name,
    required double sellingPrice,
    required double buyingPrice,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref
          .read(addItemUseCaseProvider)
          .call(
            companyId: companyId,
            companyName: companyName,
            typeId: typeId,
            typeName: typeName,
            name: name,
            sellingPrice: sellingPrice,
            buyingPrice: buyingPrice,
            notes: notes,
          );
    } on ItemException catch (error) {
      return error.code == ItemExceptionCodes.nameDuplicate
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

  Future<SaveResult> updateItem({
    required String id,
    required String companyId,
    required String companyName,
    required String typeId,
    required String typeName,
    required String name,
    required double sellingPrice,
    required double buyingPrice,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref
          .read(updateItemUseCaseProvider)
          .call(
            id: id,
            companyId: companyId,
            companyName: companyName,
            typeId: typeId,
            typeName: typeName,
            name: name,
            sellingPrice: sellingPrice,
            buyingPrice: buyingPrice,
            notes: notes,
          );
    } on ItemException catch (error) {
      return error.code == ItemExceptionCodes.nameDuplicate
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

  Future<DeleteResult> deleteItem(String id) async {
    if (_isSaving) return DeleteResult.failure;

    _isSaving = true;
    try {
      await ref.read(deleteItemUseCaseProvider).call(id);
    } catch (_) {
      return DeleteResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return DeleteResult.success;
  }
}

final itemsProvider = AsyncNotifierProvider<ItemsNotifier, List<Item>>(
  ItemsNotifier.new,
);
