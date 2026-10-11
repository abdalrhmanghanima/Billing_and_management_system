import 'package:billing_and_sales_management/domain/invoices/repositories/invoice_repository.dart';

class GetNextBillNumber {
  const GetNextBillNumber(this.repository);

  final InvoiceRepository repository;

  Future<int> call() {
    return repository.getNextBillNumber();
  }
}
