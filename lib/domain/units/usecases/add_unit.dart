import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';

class AddUnit {
  const AddUnit(this.repository);

  final UnitRepository repository;

  Future<void> call(String name, String notes) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const UnitException(UnitExceptionCodes.nameRequired);
    }

    return repository.addUnit(Unit(name: trimmedName, notes: notes.trim()));
  }
}
