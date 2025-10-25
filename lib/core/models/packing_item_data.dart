import 'package:cloud_firestore/cloud_firestore.dart';

class PackingItemData {
  final String id;
  final String category;
  final String itemName;
  final bool checked;

  PackingItemData({
    required this.id,
    required this.category,
    required this.itemName,
    required this.checked,
  });

  // ----- Factory from Firestore -----
  factory PackingItemData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackingItemData(
      id: doc.id,
      category: data['category'],
      itemName: data['itemName'],
      checked: data['checked'] ?? false,
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'category': category,
    'itemName': itemName,
    'checked': checked,
  };
}
