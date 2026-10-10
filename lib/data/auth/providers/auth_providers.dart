import 'package:billing_and_sales_management/data/auth/datasources/remote/auth_remote_data_source.dart';
import 'package:billing_and_sales_management/data/auth/datasources/remote/firebase_auth_data_source.dart';
import 'package:billing_and_sales_management/data/auth/repositories/auth_repository_impl.dart';
import 'package:billing_and_sales_management/domain/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => FirebaseAuthDataSource(FirebaseAuth.instance),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);
