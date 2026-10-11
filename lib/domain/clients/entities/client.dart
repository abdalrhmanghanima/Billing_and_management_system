class Client {
  const Client({
    this.id = '',
    required this.number,
    required this.name,
    required this.phone,
    required this.address,
  });

  final String id;
  final int number;
  final String name;
  final String phone;
  final String address;

  static String normalizeName(String name) => name.trim().toLowerCase();

  String get initials {
    final letters = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .join();

    if (letters.isEmpty) return '';

    return letters
        .substring(0, letters.length >= 2 ? 2 : letters.length)
        .toUpperCase();
  }
}
