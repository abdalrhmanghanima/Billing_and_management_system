import 'package:billing_and_sales_management/data/types/models/item_type_model.dart';

abstract interface class TypeRemoteDataSource {
  Future<List<ItemTypeModel>> getTypes();

  Future<void> addType(ItemTypeModel type);
}
