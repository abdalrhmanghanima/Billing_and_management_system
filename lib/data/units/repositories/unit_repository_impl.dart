import 'package:billing_and_sales_management/data/units/datasources/remote/unit_remote_data_source.dart';
import 'package:billing_and_sales_management/data/units/models/unit_model.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';

class UnitRepositoryImpl implements UnitRepository {
  UnitRepositoryImpl(this._remoteDataSource);

  final UnitRemoteDataSource _remoteDataSource;

  @override
  Future<List<Unit>> getUnits() {
    return _remoteDataSource.getUnits();
  }

  @override
  Future<void> addUnit(Unit unit) {
    return _remoteDataSource.addUnit(UnitModel.fromEntity(unit));
  }

  @override
  Future<void> updateUnit(Unit unit) {
    return _remoteDataSource.updateUnit(UnitModel.fromEntity(unit));
  }

  @override
  Future<void> deleteUnit(String id) {
    return _remoteDataSource.deleteUnit(id);
  }
}
