import 'package:billing_and_sales_management/data/invoices/models/sales_invoice_model.dart';

abstract interface class InvoiceRemoteDataSource {
  Future<List<SalesInvoiceModel>> getInvoices();

  Future<SalesInvoiceModel> addInvoice(SalesInvoiceModel invoice);

  Future<int> getNextBillNumber();
}
