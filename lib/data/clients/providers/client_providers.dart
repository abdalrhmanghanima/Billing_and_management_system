import 'package:billing_and_sales_management/data/clients/datasources/remote/client_remote_data_source.dart';
import 'package:billing_and_sales_management/data/clients/datasources/remote/firebase_client_data_source.dart';
import 'package:billing_and_sales_management/data/clients/repositories/client_repository_impl.dart';
import 'package:billing_and_sales_management/domain/clients/repositories/client_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientRemoteDataSourceProvider = Provider<ClientRemoteDataSource>(
  (ref) => FirebaseClientRemoteDataSource(FirebaseFirestore.instance),
);

final clientRepositoryProvider = Provider<ClientRepository>(
  (ref) => ClientRepositoryImpl(ref.watch(clientRemoteDataSourceProvider)),
);
