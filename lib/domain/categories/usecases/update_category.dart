import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call(String id, String name, String notes) {
    if (id.trim().isEmpty) {
      throw const CategoryException(CategoryExceptionCodes.notFound);
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const CategoryException(CategoryExceptionCodes.nameRequired);
    }

    return repository.updateCategory(
      Category(id: id.trim(), name: trimmedName, notes: notes.trim()),
    );
  }
}
