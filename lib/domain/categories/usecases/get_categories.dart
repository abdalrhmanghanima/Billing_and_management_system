import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this.repository);

  final CategoryRepository repository;

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}
