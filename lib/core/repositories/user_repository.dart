import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/core/utils/image_utils.dart';
import 'package:tripora/features/trip/models/trip_data.dart';
import 'package:tripora/features/user/models/user_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/trip/models/trip.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final String _uid;
  final FirebaseStorageService _storageService;

  UserRepository(this._firestoreService, this._uid, this._storageService);

  bool get idUidEmpty => _uid.isEmpty;

  // ----- User Profile -----
  Future<UserData?> getUserProfile() => _firestoreService.getUser(_uid);
  // Future<void> updateUserProfile(UserData user) =>
  //     _firestoreService.updateUser(user);
  // Future<void> createUserProfile(UserData user) =>
  //     _firestoreService.updateUser(user);
  // ----- Trip -----
  // Future<List<TripData>> getUserTrips() => _firestore.getTrips(_uid);
  // Future<void> addUserTrip(TripData trip) => _firestore.addTrip(_uid, trip);
  Future<String?> uploadProfileImage({
    required File file,
    required void Function(double progress)? onProgress,
    bool deletePrevious = true,
  }) async {
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storagePath = 'user_profile_images/$_uid/$filename';

    // ✅ Step 1: Compress the image until it's <1MB
    File compressedFile = await compressUntilUnderLimit(file, maxSizeMB: 1);

    // ✅ Step 2: Upload to Firebase Storage
    final uploadTask = await _storageService.uploadFile(
      storagePath,
      compressedFile,
    );

    final completer = Completer<String?>();

    uploadTask.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0 && onProgress != null) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    }, onError: (e) => completer.completeError(e));

    try {
      final snapshot = await uploadTask;
      final downloadUrl = await _storageService.getDownloadUrl(
        snapshot.ref.fullPath,
      );

      // ✅ Step 3: Update Firestore user document
      final userDoc = await _firestoreService.getUserDoc(_uid);
      final previousStoragePath =
          userDoc.data()?['profileStoragePath'] as String?;

      if (!await file.exists()) {
        throw Exception("File not found at ${file.path}");
      }

      await _firestoreService.updateUser(_uid, {
        'profileImageUrl': downloadUrl,
        'profileStoragePath': storagePath,
        'profileUpdatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ Step 4: Clean up old file if needed
      if (deletePrevious &&
          previousStoragePath != null &&
          previousStoragePath.isNotEmpty) {
        await _storageService.deleteFile(previousStoragePath);
      }

      completer.complete(downloadUrl);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
