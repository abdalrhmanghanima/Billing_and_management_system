import 'package:billing_and_sales_management/data/companies/datasources/remote/company_remote_data_source.dart';
import 'package:billing_and_sales_management/data/companies/datasources/remote/firebase_company_data_source.dart';
import 'package:billing_and_sales_management/data/companies/repositories/company_repository_impl.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>(
  (ref) => FirebaseCompanyRemoteDataSource(FirebaseFirestore.instance),
);

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => CompanyRepositoryImpl(ref.watch(companyRemoteDataSourceProvider)),
);
