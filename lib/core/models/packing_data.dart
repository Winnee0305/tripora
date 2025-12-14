import 'package:cloud_firestore/cloud_firestore.dart';

class PackingData {
  final String id;
  String category;
  String? name; // <-- nullable to allow placeholder for category
  bool isPacked;
  int? quantity; // AI-generated quantity
  String? notes; // AI-generated reason/notes
  String? priority; // essential, recommended, optional

  PackingData({
    required this.id,
    required this.category,
    this.name,
    required this.isPacked,
    this.quantity,
    this.notes,
    this.priority,
  });

  // ----- Factory from Firestore -----
  factory PackingData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackingData(
      id: doc.id,
      category: data['category'] ?? '',
      name: data['name'], // can be null
      isPacked: data['isPacked'] ?? false,
      quantity: data['quantity'],
      notes: data['notes'],
      priority: data['priority'],
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'category': category,
    'name': name, // can be null
    'isPacked': isPacked,
    'quantity': quantity,
    'notes': notes,
    'priority': priority,
  };

  // ----- Copy With -----
  PackingData copyWith({
    String? id,
    String? category,
    String? name,
    bool? isPacked,
    int? quantity,
    String? notes,
    String? priority,
  }) {
    return PackingData(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      isPacked: isPacked ?? this.isPacked,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
    );
  }

  // ----- Empty -----
  static PackingData empty() {
    return PackingData(id: '', category: '', name: null, isPacked: false);
  }

  // ----- Helper to identify placeholder -----
  bool get isPlaceholder => name == null || name!.isEmpty;
}
