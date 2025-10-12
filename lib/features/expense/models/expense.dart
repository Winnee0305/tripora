class Expense {
  final String name;
  final String? description;
  final String location;
  final String category;
  final double amount;
  final DateTime date;

  Expense({
    required this.name,
    this.description,
    required this.location,
    required this.category,
    required this.amount,
    required this.date,
  });
}
