class ItemType {
  const ItemType({
    this.id = '',
    required this.name,
    required this.companyId,
    required this.companyName,
    this.notes = '',
  });

  final String id;
  final String name;
  final String companyId;
  final String companyName;
  final String notes;

  static String normalizeName(String name) => name.trim().toLowerCase();
}
