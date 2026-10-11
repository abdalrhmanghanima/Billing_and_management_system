import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';

abstract interface class InvoiceRepository {
  Future<List<SalesInvoice>> getInvoices();

  Future<SalesInvoice> addInvoice(SalesInvoice invoice);

  Future<int> getNextBillNumber();
}
