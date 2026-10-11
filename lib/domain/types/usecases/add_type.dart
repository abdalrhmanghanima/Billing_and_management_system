import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class AddType {
  const AddType(this.repository);

  final TypeRepository repository;

  Future<void> call({
    required String companyId,
    required String companyName,
    required String name,
    required String notes,
  }) {
    final trimmedName = name.trim();
    if (companyId.trim().isEmpty) {
      throw const TypeException(TypeExceptionCodes.companyRequired);
    }
    if (trimmedName.isEmpty) {
      throw const TypeException(TypeExceptionCodes.nameRequired);
    }

    return repository.addType(
      ItemType(
        name: trimmedName,
        companyId: companyId.trim(),
        companyName: companyName.trim(),
        notes: notes.trim(),
      ),
    );
  }
}
