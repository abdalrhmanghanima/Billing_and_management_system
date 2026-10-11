import 'package:billing_and_sales_management/data/items/datasources/remote/firebase_item_data_source.dart';
import 'package:billing_and_sales_management/data/items/datasources/remote/item_remote_data_source.dart';
import 'package:billing_and_sales_management/data/items/repositories/item_repository_impl.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemRemoteDataSourceProvider = Provider<ItemRemoteDataSource>(
  (ref) => FirebaseItemRemoteDataSource(FirebaseFirestore.instance),
);

final itemRepositoryProvider = Provider<ItemRepository>(
  (ref) => ItemRepositoryImpl(ref.watch(itemRemoteDataSourceProvider)),
);
