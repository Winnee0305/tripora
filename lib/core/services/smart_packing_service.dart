import 'package:tripora/features/packing/models/packing_item.dart';

class SmartPackingService {
  List<PackingItem> getMockMelakaTripList() {
    return [
      // 🧾 Documents
      PackingItem(name: 'Passport', category: 'Documents'),
      PackingItem(name: 'Credit Card', category: 'Documents'),
      PackingItem(name: 'Foreign Currency', category: 'Documents'),
      PackingItem(name: 'International Driving Permit', category: 'Documents'),

      // 👕 Clothing
      PackingItem(name: 'Tops', category: 'Clothing'),
      PackingItem(name: 'Pants', category: 'Clothing'),
      PackingItem(name: 'Underwear', category: 'Clothing'),
      PackingItem(name: 'Pajamas', category: 'Clothing'),
      PackingItem(name: 'Shoes and Slippers', category: 'Clothing'),
      PackingItem(name: 'Socks', category: 'Clothing'),

      // 🔌 Electronics
      PackingItem(name: 'Mobile Phone', category: 'Electronics'),
      PackingItem(name: 'Power Bank', category: 'Electronics'),
      PackingItem(name: 'Phone Charger', category: 'Electronics'),
      PackingItem(name: 'SIM Card', category: 'Electronics'),
      PackingItem(name: 'Headphones', category: 'Electronics'),

      // 🧴 Toiletries
      PackingItem(name: 'Sunscreen', category: 'Toiletries'),
      PackingItem(
        name: 'Toothbrush / Toothpaste / Towel',
        category: 'Toiletries',
      ),
      PackingItem(
        name: 'Face Wash / Shower Gel / Shampoo',
        category: 'Toiletries',
      ),
      PackingItem(name: 'Personal Medication', category: 'Toiletries'),
    ];
  }
}
