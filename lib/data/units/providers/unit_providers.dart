import 'package:billing_and_sales_management/data/units/datasources/remote/firebase_unit_data_source.dart';
import 'package:billing_and_sales_management/data/units/datasources/remote/unit_remote_data_source.dart';
import 'package:billing_and_sales_management/data/units/repositories/unit_repository_impl.dart';
import 'package:billing_and_sales_management/domain/units/repositories/unit_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitRemoteDataSourceProvider = Provider<UnitRemoteDataSource>(
  (ref) => FirebaseUnitRemoteDataSource(FirebaseFirestore.instance),
);

final unitRepositoryProvider = Provider<UnitRepository>(
  (ref) => UnitRepositoryImpl(ref.watch(unitRemoteDataSourceProvider)),
);
