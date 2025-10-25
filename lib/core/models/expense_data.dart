import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseData {
  final String id;
  final double budget;

  ExpenseData({required this.id, required this.budget});

  // ----- Factory from Firestore -----
  factory ExpenseData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseData(id: doc.id, budget: data['budget']);
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {'budget': budget};
}
