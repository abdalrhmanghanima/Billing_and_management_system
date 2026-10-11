import 'package:billing_and_sales_management/data/items/datasources/remote/item_remote_data_source.dart';
import 'package:billing_and_sales_management/data/items/models/item_model.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._remoteDataSource);

  final ItemRemoteDataSource _remoteDataSource;

  @override
  Future<List<Item>> getItems() {
    return _remoteDataSource.getItems();
  }

  @override
  Future<void> addItem(Item item) {
    return _remoteDataSource.addItem(ItemModel.fromEntity(item));
  }
}
