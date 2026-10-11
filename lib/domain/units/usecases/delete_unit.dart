import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';

class DeleteUnit {
  const DeleteUnit(this.repository);

  final UnitRepository repository;

  Future<void> call(String id) {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const UnitException(UnitExceptionCodes.notFound);
    }

    return repository.deleteUnit(trimmedId);
  }
}
