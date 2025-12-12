import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/expense_data.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/packing_data.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/features/expense/models/expense.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  // ----- User Profile -----
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return usersCollection.doc(uid).get();
  }

  Future<UserData?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    return doc.exists ? UserData.fromFirestore(doc) : null;
  }

  // Future<void> updateUser(UserData user) async {
  //   await _firestore.collection('users').doc(user.uid).update(user.toMap());
  // }
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).update(data);
    } on FirebaseException catch (e) {
      // Optional: handle specific Firestore errors (e.g., not found)
      if (e.code == 'not-found') {
        // If the doc doesn't exist, create it instead
        await usersCollection.doc(uid).set(data);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // ----- User - Trips
  Future<DocumentSnapshot<Map<String, dynamic>>> getTripDoc(
    String uid,
    String tripId,
  ) {
    return usersCollection.doc(uid).collection('trips').doc(tripId).get();
  }

  Future<void> addTrip(String uid, TripData trip) async {
    final tripId = trip.tripId.isNotEmpty == true
        ? trip.tripId
        : usersCollection.doc(uid).collection('trips').doc().id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .set(trip.copyWith(tripId: tripId).toMap());
  }

  Future<List<TripData>> getTrips(String uid) async {
    final snapshot = await usersCollection.doc(uid).collection('trips').get();
    return snapshot.docs.map(TripData.fromFirestore).toList();
  }

  // Future<void> deleteTrip(String uid, String tripId) async {
  //   await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
  // }
  Future<void> deleteTrip(String uid, String tripId) async {
    try {
      await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
      print('Trip deleted: $tripId');
    } catch (e) {
      print('Failed to delete trip: $e');
    }
  }

  Future<void> updateTrip(String uid, TripData trip) async {
    // Update the trip document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(trip.tripId)
        .update(trip.toMap());

    // Additional step: remove the trip image in firestore
  }

  // ----- User - Trip - Itineraries -----
  Future<DocumentSnapshot<Map<String, dynamic>>> getItineraryDoc(
    String uid,
    String tripId,
    String itineraryId,
  ) {
    return usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itineraryId)
        .get();
  }

  Future<void> addItinerary(
    String uid,
    ItineraryData itinerary,
    String tripId,
  ) async {
    print('Adding itinerary for tripId: $tripId');
    // Use existing id if present, otherwise generate a new one
    final itineraryId = (itinerary.id.isNotEmpty)
        ? itinerary.id
        : usersCollection
              .doc(uid)
              .collection('trips')
              .doc(tripId)
              .collection('itineraries')
              .doc()
              .id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itineraryId)
        .set(
          itinerary.copyWith(id: itineraryId).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<List<ItineraryData>> getItineraries(String uid, String tripId) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .get();

    // Filter out lodging documents, include destinations and notes
    return snapshot.docs
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          final type = data?['type'];
          return type == null || type == 'destination' || type == 'note';
        })
        .map(ItineraryData.fromFirestore)
        .toList();
  }

  // Future<void> deleteTrip(String uid, String tripId) async {
  //   await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
  // }
  Future<void> deleteItinerary(
    String uid,
    String tripId,
    String itineraryId,
  ) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc(itineraryId)
          .delete();
      print('Itinerary deleted: $itineraryId');
    } catch (e) {
      print('Failed to delete itinerary: $e');
    }
  }

  Future<void> updateItinerary(
    String uid,
    ItineraryData itinerary,
    String tripId,
  ) async {
    // Update the itinerary document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itinerary.id)
        .update(itinerary.toMap());
  }

  // ======= Expenses =======
  Future<DocumentSnapshot<Map<String, dynamic>>> getExpenseDoc(
    String uid,
    String tripId,
    String expenseId,
  ) {
    return usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .doc(expenseId)
        .get();
  }

  Future<void> addExpense(
    String uid,
    ExpenseData expense,
    String tripId,
  ) async {
    print('Adding itinerary for tripId: $tripId');
    // Use existing id if present, otherwise generate a new one
    final expenseId = (expense.id.isNotEmpty)
        ? expense.id
        : usersCollection
              .doc(uid)
              .collection('trips')
              .doc(tripId)
              .collection('expenses')
              .doc()
              .id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .doc(expenseId)
        .set(expense.copyWith(id: expenseId).toMap(), SetOptions(merge: true));
  }

  Future<List<ExpenseData>> getExpenses(String uid, String tripId) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .get();
    return snapshot.docs.map(ExpenseData.fromFirestore).toList();
  }

  Future<void> deleteExpense(
    String uid,
    String expenseId,
    String tripId,
  ) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('trips')
          .doc(tripId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
      print('Expense deleted: $expenseId');
    } catch (e) {
      print('Failed to delete expense: $e');
    }
  }

  Future<void> updateExpense(
    String uid,
    ExpenseData expense,
    String tripId,
  ) async {
    // Update the itinerary document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toMap());
  }

  Future<double> getExpenseBudget(String uid, String tripId) async {
    final tripDoc = await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .get();
    final data = tripDoc.data();
    if (data != null && data.containsKey('expenseBudget')) {
      return (data['expenseBudget'] as num).toDouble();
    }
    return 0.0; // Default budget if not set
  }

  Future<void> updateExpenseBudget(
    String uid,
    double newBudget,
    String tripId,
  ) async {
    await usersCollection.doc(uid).collection('trips').doc(tripId).update({
      'expenseBudget': newBudget,
    });
  }

  // ======= Expenses =======
  Future<DocumentSnapshot<Map<String, dynamic>>> getPackingDoc(
    String uid,
    String tripId,
    String packingId,
  ) {
    return usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('packing')
        .doc(packingId)
        .get();
  }

  Future<void> addPackingItem(
    String uid,
    PackingData packing,
    String tripId,
  ) async {
    print('Adding itinerary for tripId: $tripId');
    // Use existing id if present, otherwise generate a new one
    final packingId = (packing.id.isNotEmpty)
        ? packing.id
        : usersCollection
              .doc(uid)
              .collection('trips')
              .doc(tripId)
              .collection('packing')
              .doc()
              .id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('packing')
        .doc(packingId)
        .set(packing.copyWith(id: packingId).toMap(), SetOptions(merge: true));
  }

  Future<List<PackingData>> getPackingItems(String uid, String tripId) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('packing')
        .get();
    return snapshot.docs.map(PackingData.fromFirestore).toList();
  }

  Future<void> deletePackingItem(
    String uid,
    String packingId,
    String tripId,
  ) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('trips')
          .doc(tripId)
          .collection('packing')
          .doc(packingId)
          .delete();
      print('Packing item deleted: $packingId');
    } catch (e) {
      print('Failed to delete packing item: $e');
    }
  }

  Future<void> updatePackingItem(
    String uid,
    PackingData packing,
    String tripId,
  ) async {
    // Update the itinerary document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('packing')
        .doc(packing.id)
        .update(packing.toMap());
  }

  // Future<double> getExpenseBudget(String uid, String tripId) async {
  //   final tripDoc = await usersCollection
  //       .doc(uid)
  //       .collection('trips')
  //       .doc(tripId)
  //       .get();
  //   final data = tripDoc.data();
  //   if (data != null && data.containsKey('expenseBudget')) {
  //     return (data['expenseBudget'] as num).toDouble();
  //   }
  //   return 0.0; // Default budget if not set
  // }

  // Future<void> updateExpenseBudget(
  //   String uid,
  //   double newBudget,
  //   String tripId,
  // ) async {
  //   await usersCollection.doc(uid).collection('trips').doc(tripId).update({
  //     'expenseBudget': newBudget,
  //   });
  // }

  // ----- Posts -----
  CollectionReference<Map<String, dynamic>> get postsCollection =>
      _firestore.collection('posts');

  Future<String> publishPost(String uid, PostData post) async {
    final postData = post.toMap();

    // Check if post already exists for this trip
    final existingPost = await getPostByTripId(uid, post.tripId);

    if (existingPost != null) {
      // Update existing post
      await postsCollection.doc(existingPost.postId).update({
        ...postData,
        'lastPublished': DateTime.now().toIso8601String(),
      });
      return existingPost.postId;
    } else {
      // Create new post
      final docRef = await postsCollection.add({
        ...postData,
        'lastPublished': DateTime.now().toIso8601String(),
      });
      return docRef.id;
    }
  }

  Future<PostData?> getPost(String postId) async {
    final doc = await postsCollection.doc(postId).get();
    return doc.exists ? PostData.fromFirestore(doc) : null;
  }

  Future<List<PostData>> getUserPosts(String userId) async {
    final snapshot = await postsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('lastPublished', descending: true)
        .get();

    return snapshot.docs.map(PostData.fromFirestore).toList();
  }

  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  Future<PostData?> getPostByTripId(String uid, String tripId) async {
    final snapshot = await postsCollection
        .where('userId', isEqualTo: uid)
        .where('tripId', isEqualTo: tripId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return PostData.fromFirestore(snapshot.docs.first);
  }
}
