import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/user_data.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<UserData?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserData.fromFirestore(doc) : null;
  }

  Future<void> updateUser(UserData user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<void> deleteItinerary(String uid, String itineraryId) async {
    await _firestore.doc('users/$uid/itineraries/$itineraryId').delete();
  }
}
