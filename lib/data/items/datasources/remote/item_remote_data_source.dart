import 'package:billing_and_sales_management/data/items/models/item_model.dart';

abstract interface class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();

  Future<void> addItem(ItemModel item);
}
