class Item {
  const Item({
    this.id = '',
    required this.name,
    required this.companyId,
    required this.companyName,
    required this.typeId,
    required this.typeName,
    required this.sellingPrice,
    required this.buyingPrice,
    this.notes = '',
  });

  final String id;
  final String name;
  final String companyId;
  final String companyName;
  final String typeId;
  final String typeName;
  final double sellingPrice;
  final double buyingPrice;
  final String notes;

  static String normalizeName(String name) => name.trim().toLowerCase();
}
