class PackingItem {
  final String name;
  final String category;
  bool isPacked;

  PackingItem({
    required this.name,
    required this.category,
    this.isPacked = false,
  });
}
