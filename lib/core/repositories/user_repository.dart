import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/services/firestore_service.dart';
import 'package:tripora/features/trip/models/trip.dart';

class UserRepository {
  final FirestoreService _firestore;
  final String _uid;

  UserRepository(this._firestore, this._uid);

  bool get idUidEmpty => _uid.isEmpty;

  // ----- User Profile -----
  Future<UserData?> getUserProfile() => _firestore.getUser(_uid);
  Future<void> updateUserProfile(UserData user) => _firestore.updateUser(user);

  // ----- Trip -----
  Future<List<TripData>> getUserTrips() => _firestore.getTrips(_uid);
  Future<void> addUserTrip(TripData trip) => _firestore.addTrip(_uid, trip);
}
