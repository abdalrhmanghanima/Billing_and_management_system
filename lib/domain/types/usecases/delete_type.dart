import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class DeleteType {
  const DeleteType(this.repository, this.itemRepository);

  final TypeRepository repository;
  final ItemRepository itemRepository;

  Future<void> call(String id) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const TypeException(TypeExceptionCodes.notFound);
    }

    final items = await itemRepository.getItems();
    final isReferenced = items.any((item) => item.typeId == trimmedId);

    if (isReferenced) {
      throw const TypeException(TypeExceptionCodes.inUse);
    }

    return repository.deleteType(trimmedId);
  }
}
