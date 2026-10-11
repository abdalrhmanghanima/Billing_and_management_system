import 'package:billing_and_sales_management/domain/items/entities/item.dart';

abstract interface class ItemRepository {
  Future<List<Item>> getItems();

  Future<void> addItem(Item item);

  Future<void> updateItem(Item item);

  Future<void> deleteItem(String id);
}
