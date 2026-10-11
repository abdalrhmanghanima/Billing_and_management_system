class Company {
  const Company({this.id = '', required this.name, this.notes = ''});

  final String id;
  final String name;
  final String notes;

  static String normalizeName(String name) => name.trim().toLowerCase();
}
