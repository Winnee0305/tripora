import 'package:tripora/core/models/packing_data.dart';

class SmartPackingService {
  List<PackingData> getMockMelakaTripList() {
    return [
      // 🧾 Documents
      PackingData(
        id: '',
        name: 'Passport',
        category: 'Documents',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Credit Card',
        category: 'Documents',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Foreign Currency',
        category: 'Documents',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'International Driving Permit',
        category: 'Documents',
        isPacked: false,
      ),

      // 👕 Clothing
      PackingData(id: '', name: 'Tops', category: 'Clothing', isPacked: false),
      PackingData(id: '', name: 'Pants', category: 'Clothing', isPacked: false),
      PackingData(
        id: '',
        name: 'Underwear',
        category: 'Clothing',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Pajamas',
        category: 'Clothing',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Shoes and Slippers',
        category: 'Clothing',
        isPacked: false,
      ),
      PackingData(id: '', name: 'Socks', category: 'Clothing', isPacked: false),

      // 🔌 Electronics
      PackingData(
        id: '',
        name: 'Mobile Phone',
        category: 'Electronics',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Power Bank',
        category: 'Electronics',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Phone Charger',
        category: 'Electronics',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'SIM Card',
        category: 'Electronics',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Headphones',
        category: 'Electronics',
        isPacked: false,
      ),

      // 🧴 Toiletries
      PackingData(
        id: '',
        name: 'Sunscreen',
        category: 'Toiletries',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Toothbrush / Toothpaste / Towel',
        category: 'Toiletries',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Face Wash / Shower Gel / Shampoo',
        category: 'Toiletries',
        isPacked: false,
      ),
      PackingData(
        id: '',
        name: 'Personal Medication',
        category: 'Toiletries',
        isPacked: false,
      ),
    ];
  }
}
