import 'package:billing_and_sales_management/data/invoices/models/invoice_line_model.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesInvoiceModel extends SalesInvoice {
  const SalesInvoiceModel({
    super.id,
    required super.billNumber,
    required super.billDate,
    required super.clientId,
    required super.clientName,
    required super.lines,
    required super.billsTotal,
    required super.percentageDiscount,
    required super.valueDiscount,
    required super.theNet,
    required super.paidUp,
    required super.theRest,
    required super.status,
  });

  factory SalesInvoiceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    final rawLines = data['lines'] as List<dynamic>? ?? const <dynamic>[];

    return SalesInvoiceModel(
      id: snapshot.id,
      billNumber: (data['billNumber'] as num?)?.toInt() ?? 0,
      billDate: data['billDate'] as String? ?? '',
      clientId: data['clientId'] as String? ?? '',
      clientName: data['clientName'] as String? ?? '',
      lines: rawLines
          .map(
            (line) => InvoiceLineModel.fromMap(
              Map<String, dynamic>.from(line as Map),
            ),
          )
          .toList(),
      billsTotal: (data['billsTotal'] as num?)?.toDouble() ?? 0,
      percentageDiscount: (data['percentageDiscount'] as num?)?.toDouble() ?? 0,
      valueDiscount: (data['valueDiscount'] as num?)?.toDouble() ?? 0,
      theNet: (data['theNet'] as num?)?.toDouble() ?? 0,
      paidUp: (data['paidUp'] as num?)?.toDouble() ?? 0,
      theRest: (data['theRest'] as num?)?.toDouble() ?? 0,
      status: data['status'] as String? ?? SalesInvoice.statusUnpaid,
    );
  }

  factory SalesInvoiceModel.fromEntity(SalesInvoice invoice) {
    return SalesInvoiceModel(
      id: invoice.id,
      billNumber: invoice.billNumber,
      billDate: invoice.billDate,
      clientId: invoice.clientId,
      clientName: invoice.clientName,
      lines: invoice.lines,
      billsTotal: invoice.billsTotal,
      percentageDiscount: invoice.percentageDiscount,
      valueDiscount: invoice.valueDiscount,
      theNet: invoice.theNet,
      paidUp: invoice.paidUp,
      theRest: invoice.theRest,
      status: invoice.status,
    );
  }

  SalesInvoiceModel copyWith({String? id, int? billNumber}) {
    return SalesInvoiceModel(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      billDate: billDate,
      clientId: clientId,
      clientName: clientName,
      lines: lines,
      billsTotal: billsTotal,
      percentageDiscount: percentageDiscount,
      valueDiscount: valueDiscount,
      theNet: theNet,
      paidUp: paidUp,
      theRest: theRest,
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'billNumber': billNumber,
      'billDate': billDate,
      'clientId': clientId,
      'clientName': clientName,
      'lines': lines
          .map((line) => InvoiceLineModel.fromEntity(line).toMap())
          .toList(),
      'billsTotal': billsTotal,
      'percentageDiscount': percentageDiscount,
      'valueDiscount': valueDiscount,
      'theNet': theNet,
      'paidUp': paidUp,
      'theRest': theRest,
      'status': status,
    };
  }
}
