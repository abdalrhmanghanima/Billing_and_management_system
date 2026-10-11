import 'package:billing_and_sales_management/domain/units/entities/unit.dart';

abstract interface class UnitRepository {
  Future<List<Unit>> getUnits();

  Future<void> addUnit(Unit unit);

  Future<void> updateUnit(Unit unit);

  Future<void> deleteUnit(String id);
}
