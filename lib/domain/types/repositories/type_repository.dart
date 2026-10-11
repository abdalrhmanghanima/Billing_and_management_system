import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';

abstract interface class TypeRepository {
  Future<List<ItemType>> getTypes();

  Future<void> addType(ItemType type);
}
