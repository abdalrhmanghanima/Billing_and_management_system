import 'package:billing_and_sales_management/data/types/datasources/remote/firebase_type_data_source.dart';
import 'package:billing_and_sales_management/data/types/datasources/remote/type_remote_data_source.dart';
import 'package:billing_and_sales_management/data/types/repositories/type_repository_impl.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeRemoteDataSourceProvider = Provider<TypeRemoteDataSource>(
  (ref) => FirebaseTypeRemoteDataSource(FirebaseFirestore.instance),
);

final typeRepositoryProvider = Provider<TypeRepository>(
  (ref) => TypeRepositoryImpl(ref.watch(typeRemoteDataSourceProvider)),
);
