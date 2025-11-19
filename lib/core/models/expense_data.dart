import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseData {
  final String id;
  final String name;
  final String? desc;
  final DateTime date;
  final double? amount;
  final ExpenseCategory category;
  final DateTime? lastUpdated;

  ExpenseData({
    required this.id,
    required this.name,
    this.desc,
    required this.date,
    this.amount,
    required this.category,
    this.lastUpdated,
  });

  // -----  Factory from Firestore -----
  factory ExpenseData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ExpenseData(
      id: doc.id,
      name: data['name'],
      desc: data['desc'],
      date: DateTime.parse(data['date']),
      amount: (data['amount'] as num?)?.toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == (data['category']),
        orElse: () => ExpenseCategory.other,
      ),
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.parse(data['lastUpdated'])
          : null,
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'date': date.toIso8601String(),
    'amount': amount,
    'category': category.name,
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  // ----- Copy With -----
  ExpenseData copyWith({
    String? id,
    String? name,
    String? desc,
    DateTime? date,
    double? amount,
    ExpenseCategory? category,
    DateTime? lastUpdated,
  }) {
    return ExpenseData(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // ----- Empty TripData -----
  factory ExpenseData.empty() {
    return ExpenseData(
      id: '',
      name: '',
      desc: null,
      date: DateTime.now(),
      amount: null,
      category: ExpenseCategory.other,
      lastUpdated: DateTime.now(),
    );
  }
}

enum ExpenseCategory {
  food,
  transport,
  accommodation,
  entertainment,
  shopping,
  other,
}
