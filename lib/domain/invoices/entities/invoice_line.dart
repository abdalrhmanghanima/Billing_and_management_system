class InvoiceLine {
  const InvoiceLine({
    this.itemId = '',
    required this.itemName,
    required this.sellingPrice,
    required this.quantity,
    this.discount = 0,
    required this.total,
  });

  final String itemId;
  final String itemName;
  final double sellingPrice;
  final double quantity;
  final double discount;
  final double total;

  static double calculateTotal({
    required double sellingPrice,
    required double quantity,
    double discount = 0,
  }) {
    final result = sellingPrice * quantity - discount;
    return result < 0 ? 0 : result;
  }
}
