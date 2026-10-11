import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';

class AddItem {
  const AddItem(this.repository);

  final ItemRepository repository;

  Future<void> call({
    required String companyId,
    required String companyName,
    required String typeId,
    required String typeName,
    required String name,
    required double sellingPrice,
    required double buyingPrice,
    required String notes,
  }) {
    final trimmedName = name.trim();

    if (companyId.trim().isEmpty) {
      throw const ItemException(ItemExceptionCodes.companyRequired);
    }
    if (typeId.trim().isEmpty) {
      throw const ItemException(ItemExceptionCodes.typeRequired);
    }
    if (trimmedName.isEmpty) {
      throw const ItemException(ItemExceptionCodes.nameRequired);
    }
    if (sellingPrice < 0) {
      throw const ItemException(ItemExceptionCodes.sellingPriceInvalid);
    }
    if (buyingPrice < 0) {
      throw const ItemException(ItemExceptionCodes.buyingPriceInvalid);
    }
    if (buyingPrice > sellingPrice) {
      throw const ItemException(ItemExceptionCodes.buyingPriceExceedsSelling);
    }

    return repository.addItem(
      Item(
        name: trimmedName,
        companyId: companyId.trim(),
        companyName: companyName.trim(),
        typeId: typeId.trim(),
        typeName: typeName.trim(),
        sellingPrice: sellingPrice,
        buyingPrice: buyingPrice,
        notes: notes.trim(),
      ),
    );
  }
}
