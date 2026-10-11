import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class UpdateType {
  const UpdateType(this.repository);

  final TypeRepository repository;

  Future<void> call({
    required String id,
    required String companyId,
    required String companyName,
    required String name,
    required String notes,
  }) {
    if (id.trim().isEmpty) {
      throw const TypeException(TypeExceptionCodes.notFound);
    }

    final trimmedName = name.trim();
    if (companyId.trim().isEmpty) {
      throw const TypeException(TypeExceptionCodes.companyRequired);
    }
    if (trimmedName.isEmpty) {
      throw const TypeException(TypeExceptionCodes.nameRequired);
    }

    return repository.updateType(
      ItemType(
        id: id.trim(),
        name: trimmedName,
        companyId: companyId.trim(),
        companyName: companyName.trim(),
        notes: notes.trim(),
      ),
    );
  }
}
