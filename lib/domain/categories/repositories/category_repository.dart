import 'package:billing_and_sales_management/domain/categories/entities/category.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getCategories();

  Future<void> addCategory(Category category);
}
