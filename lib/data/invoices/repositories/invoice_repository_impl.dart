import 'package:billing_and_sales_management/data/invoices/datasources/remote/invoice_remote_data_source.dart';
import 'package:billing_and_sales_management/data/invoices/models/sales_invoice_model.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/invoices/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._remoteDataSource);

  final InvoiceRemoteDataSource _remoteDataSource;

  @override
  Future<List<SalesInvoice>> getInvoices() {
    return _remoteDataSource.getInvoices();
  }

  @override
  Future<SalesInvoice> addInvoice(SalesInvoice invoice) {
    return _remoteDataSource.addInvoice(SalesInvoiceModel.fromEntity(invoice));
  }

  @override
  Future<int> getNextBillNumber() {
    return _remoteDataSource.getNextBillNumber();
  }
}
