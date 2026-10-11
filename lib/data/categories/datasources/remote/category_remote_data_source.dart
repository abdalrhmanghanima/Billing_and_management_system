import 'package:billing_and_sales_management/data/categories/models/category_model.dart';

abstract interface class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<void> addCategory(CategoryModel category);
}
