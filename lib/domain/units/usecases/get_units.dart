import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';

class GetUnits {
  const GetUnits(this.repository);

  final UnitRepository repository;

  Future<List<Unit>> call() {
    return repository.getUnits();
  }
}
