import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';

class UpdateUnit {
  const UpdateUnit(this.repository);

  final UnitRepository repository;

  Future<void> call(String id, String name, String notes) {
    if (id.trim().isEmpty) {
      throw const UnitException(UnitExceptionCodes.notFound);
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const UnitException(UnitExceptionCodes.nameRequired);
    }

    return repository.updateUnit(
      Unit(id: id.trim(), name: trimmedName, notes: notes.trim()),
    );
  }
}
