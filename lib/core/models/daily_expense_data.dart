import 'package:cloud_firestore/cloud_firestore.dart';

class DailyExpense {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final String category;

  DailyExpense({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.category,
  });

  // ----- Factory from Firestore -----
  factory DailyExpense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyExpense(
      id: doc.id,
      date: DateTime.parse(data['date']),
      amount: data['amount'],
      description: data['description'],
      category: data['category'],
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'amount': amount,
    'description': description,
    'category': category,
  };
}
