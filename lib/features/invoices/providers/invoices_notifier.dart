import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/invoice_exception.dart';
import 'package:billing_and_sales_management/data/invoices/providers/invoice_providers.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/invoices/usecases/add_invoice.dart';
import 'package:billing_and_sales_management/domain/invoices/usecases/get_invoices.dart';
import 'package:billing_and_sales_management/domain/invoices/usecases/get_next_bill_number.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getInvoicesUseCaseProvider = Provider<GetInvoices>(
  (ref) => GetInvoices(ref.watch(invoiceRepositoryProvider)),
);

final addInvoiceUseCaseProvider = Provider<AddInvoice>(
  (ref) => AddInvoice(ref.watch(invoiceRepositoryProvider)),
);

final getNextBillNumberUseCaseProvider = Provider<GetNextBillNumber>(
  (ref) => GetNextBillNumber(ref.watch(invoiceRepositoryProvider)),
);

class InvoicesNotifier extends AsyncNotifier<List<SalesInvoice>> {
  bool _isSaving = false;

  @override
  Future<List<SalesInvoice>> build() {
    return ref.read(getInvoicesUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getInvoicesUseCaseProvider).call(),
    );
  }

  Future<({SaveResult result, SalesInvoice? invoice})> addInvoice({
    required String billDate,
    required String clientId,
    required String clientName,
    required List<InvoiceLine> lines,
    required double percentageDiscount,
    required double valueDiscount,
    required double paidUp,
  }) async {
    if (_isSaving) return (result: SaveResult.failure, invoice: null);

    _isSaving = true;
    SalesInvoice? invoice;
    try {
      invoice = await ref
          .read(addInvoiceUseCaseProvider)
          .call(
            billDate: billDate,
            clientId: clientId,
            clientName: clientName,
            lines: lines,
            percentageDiscount: percentageDiscount,
            valueDiscount: valueDiscount,
            paidUp: paidUp,
          );
    } on InvoiceException catch (_) {
      return (result: SaveResult.failure, invoice: null);
    } catch (_) {
      return (result: SaveResult.failure, invoice: null);
    } finally {
      _isSaving = false;
    }

    await refresh();

    return (result: SaveResult.success, invoice: invoice);
  }
}

final invoicesProvider =
    AsyncNotifierProvider<InvoicesNotifier, List<SalesInvoice>>(
      InvoicesNotifier.new,
    );

final nextBillNumberProvider = FutureProvider<int>(
  (ref) => ref.watch(getNextBillNumberUseCaseProvider).call(),
);
