import 'package:cloud_firestore/cloud_firestore.dart';

class PackingData {
  final String id;
  String category;
  String? name; // <-- nullable to allow placeholder for category
  bool isPacked;

  PackingData({
    required this.id,
    required this.category,
    this.name,
    required this.isPacked,
  });

  // ----- Factory from Firestore -----
  factory PackingData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackingData(
      id: doc.id,
      category: data['category'] ?? '',
      name: data['name'], // can be null
      isPacked: data['isPacked'] ?? false,
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'category': category,
    'name': name, // can be null
    'isPacked': isPacked,
  };

  // ----- Copy With -----
  PackingData copyWith({
    String? id,
    String? category,
    String? name,
    bool? isPacked,
  }) {
    return PackingData(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      isPacked: isPacked ?? this.isPacked,
    );
  }

  // ----- Empty -----
  static PackingData empty() {
    return PackingData(id: '', category: '', name: null, isPacked: false);
  }

  // ----- Helper to identify placeholder -----
  bool get isPlaceholder => name == null || name!.isEmpty;
}
