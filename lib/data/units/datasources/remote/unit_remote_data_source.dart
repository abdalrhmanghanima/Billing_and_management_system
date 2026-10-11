import 'package:billing_and_sales_management/data/units/models/unit_model.dart';

abstract interface class UnitRemoteDataSource {
  Future<List<UnitModel>> getUnits();

  Future<void> addUnit(UnitModel unit);

  Future<void> updateUnit(UnitModel unit);

  Future<void> deleteUnit(String id);
}
