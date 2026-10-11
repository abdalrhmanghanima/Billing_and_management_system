import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';

class DeleteCategory {
  const DeleteCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call(String id) {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const CategoryException(CategoryExceptionCodes.notFound);
    }

    return repository.deleteCategory(trimmedId);
  }
}
