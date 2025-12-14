import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tripora/core/models/expense_data.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/models/packing_data.dart';
import 'package:tripora/core/models/poi_history_data.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/models/user_data.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  // ----- User Profile -----
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return usersCollection.doc(uid).get();
  }

  Future<UserData?> getUser(String uid) async {
    try {
      debugPrint("🔍 Fetching user document for UID: $uid");
      final doc = await usersCollection.doc(uid).get();
      debugPrint("📄 Document exists: ${doc.exists}");
      if (doc.exists) {
        debugPrint("📋 Document data: ${doc.data()}");
      }
      return doc.exists ? UserData.fromFirestore(doc) : null;
    } catch (e) {
      debugPrint("❌ Error fetching user document: $e");
      rethrow;
    }
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
      // Check if trip has a published post
      final post = await getPostByTripId(uid, tripId);

      if (post != null) {
        // Mark the post as orphaned (trip deleted)
        await markPostAsOrphaned(post.postId);
        print('🔗 Post ${post.postId} marked as orphaned after trip deletion');
      }

      await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
      print('🗑️ Trip deleted: $tripId');
    } catch (e) {
      print('❌ Failed to delete trip: $e');
      rethrow;
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

  // ----- Posts -----
  CollectionReference<Map<String, dynamic>> get postsCollection =>
      _firestore.collection('posts');

  Future<String> publishPost(
    String uid,
    PostData post,
    List<ItineraryData> itineraries,
    List<LodgingData> lodgings,
    List<FlightData> flights,
  ) async {
    final postData = post.toMap();

    // Check if post already exists for this trip
    final existingPost = post.tripId != null
        ? await getPostByTripId(uid, post.tripId!)
        : null;

    String postId;
    if (existingPost != null) {
      // Update existing post
      postId = existingPost.postId;
      await postsCollection.doc(postId).update({
        ...postData,
        'lastPublished': DateTime.now().toIso8601String(),
      });

      // Delete existing subcollections before adding new ones
      await _deletePostSubcollections(postId);
    } else {
      // Create new post
      final docRef = await postsCollection.add({
        ...postData,
        'lastPublished': DateTime.now().toIso8601String(),
      });
      postId = docRef.id;
    }

    // Add subcollections
    await _addPostItineraries(postId, itineraries);
    await _addPostLodgings(postId, lodgings);
    await _addPostFlights(postId, flights);

    return postId;
  }

  Future<void> _deletePostSubcollections(String postId) async {
    final postRef = postsCollection.doc(postId);

    // Delete itineraries
    final itinerariesSnapshot = await postRef.collection('itineraries').get();
    for (final doc in itinerariesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete lodgings
    final lodgingsSnapshot = await postRef.collection('lodgings').get();
    for (final doc in lodgingsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete flights
    final flightsSnapshot = await postRef.collection('flights').get();
    for (final doc in flightsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _addPostItineraries(
    String postId,
    List<ItineraryData> itineraries,
  ) async {
    final postRef = postsCollection.doc(postId);
    final batch = _firestore.batch();

    for (final itinerary in itineraries) {
      final docRef = postRef.collection('itineraries').doc(itinerary.id);
      batch.set(docRef, itinerary.toMap());
    }

    await batch.commit();
  }

  Future<void> _addPostLodgings(
    String postId,
    List<LodgingData> lodgings,
  ) async {
    debugPrint('🏨 Adding ${lodgings.length} lodgings to post $postId');

    if (lodgings.isEmpty) {
      debugPrint('⚠️ No lodgings to add');
      return;
    }

    final postRef = postsCollection.doc(postId);
    final batch = _firestore.batch();

    for (final lodging in lodgings) {
      final docRef = postRef.collection('lodgings').doc(lodging.id);
      debugPrint('  - Adding lodging: ${lodging.id} - ${lodging.name}');
      batch.set(docRef, lodging.toMap());
    }

    await batch.commit();
    debugPrint('✅ Successfully added ${lodgings.length} lodgings');
  }

  Future<void> _addPostFlights(String postId, List<FlightData> flights) async {
    final postRef = postsCollection.doc(postId);
    final batch = _firestore.batch();

    for (final flight in flights) {
      final docRef = postRef.collection('flights').doc(flight.id);
      batch.set(docRef, flight.toMap());
    }

    await batch.commit();
  }

  Future<PostData?> getPost(String postId) async {
    final doc = await postsCollection.doc(postId).get();
    return doc.exists ? PostData.fromFirestore(doc) : null;
  }

  Future<List<ItineraryData>> getPostItineraries(String postId) async {
    // Note: Using orderBy on multiple fields requires a composite index
    // For now, we'll fetch all and sort in memory
    final snapshot = await postsCollection
        .doc(postId)
        .collection('itineraries')
        .get();

    final itineraries = snapshot.docs
        .map((doc) => ItineraryData.fromFirestore(doc))
        .toList();

    // Sort in memory by date first, then by sequence
    itineraries.sort((a, b) {
      final dateComparison = a.date.compareTo(b.date);
      if (dateComparison != 0) return dateComparison;
      return a.sequence.compareTo(b.sequence);
    });

    return itineraries;
  }

  Future<List<LodgingData>> getPostLodgings(String postId) async {
    final snapshot = await postsCollection
        .doc(postId)
        .collection('lodgings')
        .get();
    return snapshot.docs.map((doc) => LodgingData.fromFirestore(doc)).toList();
  }

  Future<List<FlightData>> getPostFlights(String postId) async {
    final snapshot = await postsCollection
        .doc(postId)
        .collection('flights')
        .get();
    return snapshot.docs.map((doc) => FlightData.fromFirestore(doc)).toList();
  }

  Future<List<PostData>> getUserPosts(String userId) async {
    // Fetch without orderBy to avoid composite index requirement
    final snapshot = await postsCollection
        .where('userId', isEqualTo: userId)
        .get();

    // Sort in memory by lastPublished (descending - newest first)
    final posts = snapshot.docs.map(PostData.fromFirestore).toList();
    posts.sort((a, b) => b.lastPublished.compareTo(a.lastPublished));

    return posts;
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

  // Get all posts (for public feed)
  Future<List<PostData>> getAllPosts({int limit = 50}) async {
    final snapshot = await postsCollection
        .orderBy('lastPublished', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map(PostData.fromFirestore).toList();
  }

  // Mark post as orphaned when trip is deleted
  Future<void> markPostAsOrphaned(String postId) async {
    await postsCollection.doc(postId).update({
      'tripId': null,
      'tripDeleted': true,
    });
  }

  // Unpublish a post (delete it)
  Future<void> unpublishPost(String postId, String? tripId) async {
    await deletePost(postId);

    // If trip still exists, remove the publishedPostId link
    if (tripId != null) {
      // Note: This will be handled by the repository layer
    }
  }

  // ----- Collected Posts -----
  Future<void> addToCollectedPosts(String uid, String postId) async {
    // Add to user's collected posts
    await usersCollection.doc(uid).collection('collectedPosts').doc(postId).set(
      {'postId': postId, 'collectedAt': DateTime.now().toIso8601String()},
    );

    // Increment collectsCount on the post
    await postsCollection.doc(postId).update({
      'collectsCount': FieldValue.increment(1),
    });
  }

  Future<void> removeFromCollectedPosts(String uid, String postId) async {
    // Remove from user's collected posts
    await usersCollection
        .doc(uid)
        .collection('collectedPosts')
        .doc(postId)
        .delete();

    // Decrement collectsCount on the post
    await postsCollection.doc(postId).update({
      'collectsCount': FieldValue.increment(-1),
    });
  }

  Future<bool> isPostCollected(String uid, String postId) async {
    final doc = await usersCollection
        .doc(uid)
        .collection('collectedPosts')
        .doc(postId)
        .get();
    return doc.exists;
  }

  Future<List<String>> getCollectedPostIds(String uid) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('collectedPosts')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // ----- Collected POIs -----
  Future<void> addToCollectedPois(String uid, String poiId) async {
    // Add to user's collected POIs
    await usersCollection.doc(uid).collection('collectedPois').doc(poiId).set({
      'poiId': poiId,
      'collectedAt': DateTime.now().toIso8601String(),
    });

    // Increment collectsCount on the POI
    await _firestore
        .collection('pois')
        .doc(poiId)
        .update({'collectsCount': FieldValue.increment(1)})
        .catchError((_) {
          // If POI document doesn't exist, create it with collectsCount
          return _firestore.collection('pois').doc(poiId).set({
            'collectsCount': 1,
          }, SetOptions(merge: true));
        });
  }

  Future<void> removeFromCollectedPois(String uid, String poiId) async {
    // Remove from user's collected POIs
    await usersCollection
        .doc(uid)
        .collection('collectedPois')
        .doc(poiId)
        .delete();

    // Decrement collectsCount on the POI
    await _firestore.collection('pois').doc(poiId).update({
      'collectsCount': FieldValue.increment(-1),
    });
  }

  Future<bool> isPoiCollected(String uid, String poiId) async {
    final doc = await usersCollection
        .doc(uid)
        .collection('collectedPois')
        .doc(poiId)
        .get();
    return doc.exists;
  }

  Future<List<String>> getCollectedPoiIds(String uid) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('collectedPois')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // ----- Place Details Cache -----
  /// Saves place details to Firestore
  Future<void> savePlaceDetails(
    String placeId,
    Map<String, dynamic> details,
  ) async {
    try {
      await _firestore.collection('pois').doc(placeId).set({
        'details': details,
        'cachedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (kDebugMode) print('✅ Place details saved in Firestore for: $placeId');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to save place details to Firestore: $e');
    }
  }

  /// Fetches place details from Firestore (without cache expiration logic)
  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final doc = await _firestore.collection('pois').doc(placeId).get();

      if (doc.exists && doc.data()?['details'] != null) {
        if (kDebugMode)
          print('✅ Fetched place details from Firestore: $placeId');
        return {
          'details': doc.data()?['details'] as Map<String, dynamic>,
          'cachedAt': doc.data()?['cachedAt'] as Timestamp?,
        };
      }
    } catch (e) {
      if (kDebugMode)
        print('⚠️ Failed to fetch place details from Firestore: $e');
    }
    return null;
  }

  // ----- POI View History -----
  /// Records a POI view to user's history
  Future<void> recordPoiViewHistory({
    required String uid,
    required String placeId,
    required String poiName,
    required String address,
    required List<String> tags,
  }) async {
    try {
      await usersCollection.doc(uid).collection('poiViewHistory').add({
        'placeId': placeId,
        'poiName': poiName,
        'address': address,
        'tags': tags,
        'viewedAt': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) print('✅ POI view recorded for user $uid: $poiName');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to record POI view: $e');
    }
  }

  /// Fetches POI view history for a user
  Future<List<PoiHistoryData>> getPoiViewHistory(
    String uid, {
    int limit = 50,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(uid)
          .collection('poiViewHistory')
          .orderBy('viewedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map(PoiHistoryData.fromFirestore).toList();
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to fetch POI view history: $e');
      return [];
    }
  }

  /// Deletes a specific POI history entry
  Future<void> deletePoiHistoryEntry(String uid, String historyId) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('poiViewHistory')
          .doc(historyId)
          .delete();
      if (kDebugMode) print('✅ POI history entry deleted: $historyId');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to delete POI history entry: $e');
    }
  }

  /// Clears all POI view history for a user
  Future<void> clearAllPoiHistory(String uid) async {
    try {
      final snapshot = await usersCollection
          .doc(uid)
          .collection('poiViewHistory')
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (kDebugMode) print('✅ All POI view history cleared for user $uid');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to clear POI view history: $e');
    }
  }

  /// Maintains POI view history to only keep the latest 50 entries
  Future<void> maintainPoiHistoryLimit(String uid, {int limit = 50}) async {
    try {
      final viewedPoisRef = usersCollection
          .doc(uid)
          .collection('poiViewHistory');

      // Get the latest 50 entries
      final latest50 = await viewedPoisRef
          .orderBy('viewedAt', descending: true)
          .limit(limit)
          .get();

      if (latest50.docs.length < limit) {
        // No need to clean up if we have less than limit entries
        return;
      }

      // Get all entries after the 50th one
      final oldSnap = await viewedPoisRef
          .orderBy('viewedAt', descending: true)
          .startAfterDocument(latest50.docs.last)
          .get();

      // Delete older entries
      if (oldSnap.docs.isNotEmpty) {
        final batch = _firestore.batch();
        for (final doc in oldSnap.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        if (kDebugMode)
          print(
            '🧹 Cleaned up ${oldSnap.docs.length} old POI history entries for user $uid',
          );
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to maintain POI history limit: $e');
    }
  }
}
