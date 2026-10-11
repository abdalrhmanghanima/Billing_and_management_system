import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';

class SalesInvoice {
  const SalesInvoice({
    this.id = '',
    required this.billNumber,
    required this.billDate,
    required this.clientId,
    required this.clientName,
    required this.lines,
    required this.billsTotal,
    required this.percentageDiscount,
    required this.valueDiscount,
    required this.theNet,
    required this.paidUp,
    required this.theRest,
    required this.status,
  });

  final String id;
  final int billNumber;
  final String billDate;
  final String clientId;
  final String clientName;
  final List<InvoiceLine> lines;
  final double billsTotal;
  final double percentageDiscount;
  final double valueDiscount;
  final double theNet;
  final double paidUp;
  final double theRest;
  final String status;

  static const String statusPaid = 'Paid';
  static const String statusUnpaid = 'Unpaid';

  bool get isPaid => status == statusPaid;

  static double calculateBillsTotal(List<InvoiceLine> lines) {
    return lines.fold(0.0, (sum, line) => sum + line.total);
  }

  static double calculateNet({
    required double billsTotal,
    required double percentageDiscount,
    required double valueDiscount,
  }) {
    final percentageAmount = (billsTotal * percentageDiscount) / 100;
    final net = billsTotal - valueDiscount - percentageAmount;
    return net < 0 ? 0 : net;
  }

  static String calculateStatus({
    required double theNet,
    required double theRest,
  }) {
    return theRest <= 0 && theNet > 0 ? statusPaid : statusUnpaid;
  }
}
