import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/data/categories/providers/category_providers.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/domain/categories/usecases/add_category.dart';
import 'package:billing_and_sales_management/domain/categories/usecases/get_categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCategoriesUseCaseProvider = Provider<GetCategories>(
  (ref) => GetCategories(ref.watch(categoryRepositoryProvider)),
);

final addCategoryUseCaseProvider = Provider<AddCategory>(
  (ref) => AddCategory(ref.watch(categoryRepositoryProvider)),
);

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  bool _isSaving = false;

  @override
  Future<List<Category>> build() {
    return ref.read(getCategoriesUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getCategoriesUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addCategory({
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref.read(addCategoryUseCaseProvider).call(name, notes);
    } on CategoryException catch (error) {
      return error.code == CategoryExceptionCodes.nameDuplicate
          ? SaveResult.duplicate
          : SaveResult.failure;
    } catch (_) {
      return SaveResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return SaveResult.success;
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
      CategoriesNotifier.new,
    );
