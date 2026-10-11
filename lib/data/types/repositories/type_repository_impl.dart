import 'package:billing_and_sales_management/data/types/datasources/remote/type_remote_data_source.dart';
import 'package:billing_and_sales_management/data/types/models/item_type_model.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class TypeRepositoryImpl implements TypeRepository {
  TypeRepositoryImpl(this._remoteDataSource);

  final TypeRemoteDataSource _remoteDataSource;

  @override
  Future<List<ItemType>> getTypes() {
    return _remoteDataSource.getTypes();
  }

  @override
  Future<void> addType(ItemType type) {
    return _remoteDataSource.addType(ItemTypeModel.fromEntity(type));
  }
}
