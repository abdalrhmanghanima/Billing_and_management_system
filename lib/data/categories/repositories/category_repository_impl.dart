import 'package:billing_and_sales_management/data/categories/datasources/remote/category_remote_data_source.dart';
import 'package:billing_and_sales_management/data/categories/models/category_model.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._remoteDataSource);

  final CategoryRemoteDataSource _remoteDataSource;

  @override
  Future<List<Category>> getCategories() {
    return _remoteDataSource.getCategories();
  }

  @override
  Future<void> addCategory(Category category) {
    return _remoteDataSource.addCategory(CategoryModel.fromEntity(category));
  }
}
