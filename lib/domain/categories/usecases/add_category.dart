import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';

class AddCategory {
  const AddCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call(String name, String notes) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const CategoryException(CategoryExceptionCodes.nameRequired);
    }

    return repository.addCategory(
      Category(name: trimmedName, notes: notes.trim()),
    );
  }
}
