import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/invoices/repositories/invoice_repository.dart';

class GetInvoices {
  const GetInvoices(this.repository);

  final InvoiceRepository repository;

  Future<List<SalesInvoice>> call() {
    return repository.getInvoices();
  }
}
