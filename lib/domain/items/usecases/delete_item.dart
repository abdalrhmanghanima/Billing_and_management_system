import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';

class DeleteItem {
  const DeleteItem(this.repository);

  final ItemRepository repository;

  Future<void> call(String id) {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const ItemException(ItemExceptionCodes.notFound);
    }

    return repository.deleteItem(trimmedId);
  }
}
