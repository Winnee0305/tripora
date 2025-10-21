import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/services/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestore;
  final String uid;

  UserRepository(this._firestore, this.uid);

  // ----- User Profile -----
  Future<UserData?> getUserProfile() => _firestore.getUser(uid);
  Future<void> updateUserProfile(UserData user) => _firestore.updateUser(user);

  Future<void> deleteItinerary(String itineraryId) =>
      _firestore.deleteItinerary(uid, itineraryId);
}
