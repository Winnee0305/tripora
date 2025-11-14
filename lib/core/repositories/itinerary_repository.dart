import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/core/utils/image_utils.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/services/firebase_auth_service.dart'; // or your AuthState class

class ItineraryRepository {
  final FirestoreService _firestoreService;
  final FirebaseStorageService _storageService;
  final String _uid; // The current user's ID

  ItineraryRepository(this._firestoreService, this._uid, this._storageService);
  // ---- CREATE ----
  Future<void> cretaeItinerary(ItineraryData itinerary, String tripId) async {
    await _firestoreService.addItinerary(_uid, itinerary, tripId);
  }

  // ---- READ (All for this trip) ----
  Future<List<ItineraryData>> getItineraries(String tripId) async {
    return await _firestoreService.getItineraries(_uid, tripId);
  }

  // // ---- UPDATE ----
  // Future<void> updateTrip(TripData trip) async {
  //   try {
  //     // ✅ Step 1: Get the trip document
  //     final tripDoc = await _firestoreService.getTripDoc(_uid, trip.tripId);

  //     if (!tripDoc.exists) {
  //       debugPrint("⚠️ Trip document not found for ID: ${trip.tripId}");
  //       return;
  //     }

  //     final previousStoragePath = tripDoc.data()?['tripStoragePath'] as String?;

  //     // ✅ Step 2: Delete previous image only if it's different
  //     if (previousStoragePath != null &&
  //         previousStoragePath.isNotEmpty &&
  //         previousStoragePath != trip.tripStoragePath) {
  //       try {
  //         await _storageService.deleteFile(previousStoragePath);
  //         debugPrint("🗑️ Deleted old trip image: $previousStoragePath");
  //       } catch (e) {
  //         debugPrint("⚠️ Failed to delete old image: $e");
  //       }
  //     }

  //     // ✅ Step 3: Update Firestore with the new trip data
  //     await _firestoreService.updateTrip(_uid, trip);
  //     debugPrint("✅ Trip updated successfully: ${trip.tripId}");
  //   } on FirebaseException catch (e) {
  //     debugPrint("🔥 Firebase error updating trip: ${e.message}");
  //     rethrow; // rethrow if you want to handle it at a higher level
  //   } catch (e, stack) {
  //     debugPrint("❌ Unexpected error updating trip: $e");
  //     debugPrint(stack.toString());
  //     rethrow;
  //   }
  // }

  // Future<String?> uploadProfileImage({
  //   required File file,
  //   required void Function(double progress)? onProgress,
  //   bool deletePrevious = true,
  // }) async {
  //   final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   final storagePath = 'user_profile_images/$_uid/$filename';

  //   // ✅ Step 1: Compress the image until it's <1MB
  //   File compressedFile = await compressUntilUnderLimit(file, maxSizeMB: 1);

  //   // ✅ Step 2: Upload to Firebase Storage
  //   final uploadTask = await _storageService.uploadFile(
  //     storagePath,
  //     compressedFile,
  //   );

  //   final completer = Completer<String?>();

  //   uploadTask.snapshotEvents.listen((snapshot) {
  //     if (snapshot.totalBytes > 0 && onProgress != null) {
  //       onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
  //     }
  //   }, onError: (e) => completer.completeError(e));

  //   try {
  //     final snapshot = await uploadTask;
  //     final downloadUrl = await _storageService.getDownloadUrl(
  //       snapshot.ref.fullPath,
  //     );

  //     // ✅ Step 3: Update Firestore user document
  //     final userDoc = await _firestoreService.getUserDoc(_uid);
  //     final previousStoragePath =
  //         userDoc.data()?['profileStoragePath'] as String?;

  //     if (!await file.exists()) {
  //       throw Exception("File not found at ${file.path}");
  //     }

  //     await _firestoreService.updateUser(_uid, {
  //       'profileImageUrl': downloadUrl,
  //       'profileStoragePath': storagePath,
  //       'profileUpdatedAt': FieldValue.serverTimestamp(),
  //     });

  //     // ✅ Step 4: Clean up old file if needed
  //     if (deletePrevious &&
  //         previousStoragePath != null &&
  //         previousStoragePath.isNotEmpty) {
  //       await _storageService.deleteFile(previousStoragePath);
  //     }

  //     completer.complete(downloadUrl);
  //   } catch (e) {
  //     completer.completeError(e);
  //   }

  //   return completer.future;
  // }

  // ---- DELETE ----
  Future<void> deleteItinerary(String itineraryId, String tripId) async {
    await _firestoreService.deleteItinerary(_uid, itineraryId, tripId);
  }

  // Future<Map<String, String>> uploadTripImage({
  //   required String tripId,
  //   required File file,
  //   required void Function(double progress)? onProgress,
  //   bool deletePrevious = true,
  // }) async {
  //   final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   final storagePath = 'trip_images/$_uid/$tripId/$filename';

  //   File compressedFile = await compressUntilUnderLimit(file, maxSizeMB: 1);

  //   final uploadTask = await _storageService.uploadFile(
  //     storagePath,
  //     compressedFile,
  //   );

  //   uploadTask.snapshotEvents.listen((snapshot) {
  //     if (snapshot.totalBytes > 0 && onProgress != null) {
  //       onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
  //     }
  //   });

  //   try {
  //     final snapshot = await uploadTask;
  //     final downloadUrl = await _storageService.getDownloadUrl(
  //       snapshot.ref.fullPath,
  //     );

  //     return {'downloadUrl': downloadUrl, 'storagePath': storagePath};
  //   } catch (e) {
  //     throw Exception('Failed to upload trip image: $e');
  //   }
  // }
}
