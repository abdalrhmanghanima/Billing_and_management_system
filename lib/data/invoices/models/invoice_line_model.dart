import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';

class InvoiceLineModel extends InvoiceLine {
  const InvoiceLineModel({
    super.itemId,
    required super.itemName,
    required super.sellingPrice,
    required super.quantity,
    super.discount,
    required super.total,
  });

  factory InvoiceLineModel.fromMap(Map<String, dynamic> map) {
    return InvoiceLineModel(
      itemId: map['itemId'] as String? ?? '',
      itemName: map['itemName'] as String? ?? '',
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0,
    );
  }

  factory InvoiceLineModel.fromEntity(InvoiceLine line) {
    return InvoiceLineModel(
      itemId: line.itemId,
      itemName: line.itemName,
      sellingPrice: line.sellingPrice,
      quantity: line.quantity,
      discount: line.discount,
      total: line.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'itemName': itemName,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
      'discount': discount,
      'total': total,
    };
  }
}
