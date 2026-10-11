import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';

class GetItems {
  const GetItems(this.repository);

  final ItemRepository repository;

  Future<List<Item>> call() {
    return repository.getItems();
  }
}
