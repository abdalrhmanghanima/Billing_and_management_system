import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/category_exception.dart';
import 'package:billing_and_sales_management/data/categories/datasources/remote/category_remote_data_source.dart';
import 'package:billing_and_sales_management/data/categories/models/category_model.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCategoryRemoteDataSource implements CategoryRemoteDataSource {
  FirebaseCategoryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'categories';

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore.collection(_collection);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _categories.get();

      final categories = snapshot.docs
          .map(CategoryModel.fromFirestore)
          .where((category) => category.name.isNotEmpty)
          .toList();

      categories.sort(
        (a, b) => Category.normalizeName(
          a.name,
        ).compareTo(Category.normalizeName(b.name)),
      );

      return categories;
    } on FirebaseException catch (error) {
      throw CategoryException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final normalizedName = Category.normalizeName(category.name);
    if (normalizedName.isEmpty) {
      throw const CategoryException(CategoryExceptionCodes.nameRequired);
    }

    final document = _categories.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(document);
        if (existing.exists) {
          throw const CategoryException(CategoryExceptionCodes.nameDuplicate);
        }

        transaction.set(document, category.toMap());
      });
    } on FirebaseException catch (error) {
      throw CategoryException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return CategoryExceptionCodes.networkRequestFailed;
      default:
        return CategoryExceptionCodes.unknown;
    }
  }
}
