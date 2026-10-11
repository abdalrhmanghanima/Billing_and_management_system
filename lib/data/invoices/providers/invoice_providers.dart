import 'package:billing_and_sales_management/data/invoices/datasources/remote/firebase_invoice_data_source.dart';
import 'package:billing_and_sales_management/data/invoices/datasources/remote/invoice_remote_data_source.dart';
import 'package:billing_and_sales_management/data/invoices/repositories/invoice_repository_impl.dart';
import 'package:billing_and_sales_management/domain/invoices/repositories/invoice_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>(
  (ref) => FirebaseInvoiceRemoteDataSource(FirebaseFirestore.instance),
);

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => InvoiceRepositoryImpl(ref.watch(invoiceRemoteDataSourceProvider)),
);
