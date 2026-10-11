import 'package:billing_and_sales_management/data/categories/datasources/remote/category_remote_data_source.dart';
import 'package:billing_and_sales_management/data/categories/datasources/remote/firebase_category_data_source.dart';
import 'package:billing_and_sales_management/data/categories/repositories/category_repository_impl.dart';
import 'package:billing_and_sales_management/domain/categories/repositories/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
  (ref) => FirebaseCategoryRemoteDataSource(FirebaseFirestore.instance),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepositoryImpl(ref.watch(categoryRemoteDataSourceProvider)),
);
