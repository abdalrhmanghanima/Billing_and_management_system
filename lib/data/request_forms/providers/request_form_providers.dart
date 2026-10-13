import 'package:billing_and_sales_management/data/request_forms/datasources/remote/firebase_request_form_data_source.dart';
import 'package:billing_and_sales_management/data/request_forms/datasources/remote/request_form_remote_data_source.dart';
import 'package:billing_and_sales_management/data/request_forms/repositories/request_form_repository_impl.dart';
import 'package:billing_and_sales_management/domain/request_forms/repositories/request_form_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestFormRemoteDataSourceProvider =
    Provider<RequestFormRemoteDataSource>(
      (ref) => FirebaseRequestFormRemoteDataSource(FirebaseFirestore.instance),
    );

final requestFormRepositoryProvider = Provider<RequestFormRepository>(
  (ref) =>
      RequestFormRepositoryImpl(ref.watch(requestFormRemoteDataSourceProvider)),
);
