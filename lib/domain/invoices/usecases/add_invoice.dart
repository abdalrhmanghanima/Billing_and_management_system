import 'package:billing_and_sales_management/core/errors/invoice_exception.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/invoices/repositories/invoice_repository.dart';

class AddInvoice {
  const AddInvoice(this.repository);

  final InvoiceRepository repository;

  Future<SalesInvoice> call({
    required String billDate,
    required String clientId,
    required String clientName,
    required List<InvoiceLine> lines,
    required double percentageDiscount,
    required double valueDiscount,
    required double paidUp,
  }) {
    final trimmedBillDate = billDate.trim();
    final trimmedClientId = clientId.trim();
    final trimmedClientName = clientName.trim();

    if (trimmedBillDate.isEmpty) {
      throw const InvoiceException(InvoiceExceptionCodes.billDateRequired);
    }
    if (trimmedClientId.isEmpty) {
      throw const InvoiceException(InvoiceExceptionCodes.clientRequired);
    }
    if (lines.isEmpty) {
      throw const InvoiceException(InvoiceExceptionCodes.itemsEmpty);
    }
    if (percentageDiscount < 0) {
      throw const InvoiceException(
        InvoiceExceptionCodes.percentageDiscountInvalid,
      );
    }
    if (valueDiscount < 0) {
      throw const InvoiceException(InvoiceExceptionCodes.valueDiscountInvalid);
    }
    if (paidUp < 0) {
      throw const InvoiceException(InvoiceExceptionCodes.paidUpInvalid);
    }

    final computedLines = <InvoiceLine>[];
    for (final line in lines) {
      final trimmedName = line.itemName.trim();

      if (trimmedName.isEmpty) {
        throw const InvoiceException(InvoiceExceptionCodes.itemNameRequired);
      }
      if (line.quantity.isNaN ||
          line.quantity.isInfinite ||
          line.quantity <= 0) {
        throw const InvoiceException(
          InvoiceExceptionCodes.quantityGreaterThanZero,
        );
      }
      if (line.discount < 0) {
        throw const InvoiceException(InvoiceExceptionCodes.discountInvalid);
      }

      computedLines.add(
        InvoiceLine(
          itemId: line.itemId,
          itemName: trimmedName,
          sellingPrice: line.sellingPrice,
          quantity: line.quantity,
          discount: line.discount,
          total: InvoiceLine.calculateTotal(
            sellingPrice: line.sellingPrice,
            quantity: line.quantity,
            discount: line.discount,
          ),
        ),
      );
    }

    final billsTotal = SalesInvoice.calculateBillsTotal(computedLines);
    final theNet = SalesInvoice.calculateNet(
      billsTotal: billsTotal,
      percentageDiscount: percentageDiscount,
      valueDiscount: valueDiscount,
    );
    final theRest = theNet - paidUp;

    return repository.addInvoice(
      SalesInvoice(
        billNumber: 0,
        billDate: trimmedBillDate,
        clientId: trimmedClientId,
        clientName: trimmedClientName,
        lines: computedLines,
        billsTotal: billsTotal,
        percentageDiscount: percentageDiscount,
        valueDiscount: valueDiscount,
        theNet: theNet,
        paidUp: paidUp,
        theRest: theRest,
        status: SalesInvoice.calculateStatus(theNet: theNet, theRest: theRest),
      ),
    );
  }
}
