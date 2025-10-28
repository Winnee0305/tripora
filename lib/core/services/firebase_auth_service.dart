import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
  // ---- DATABASE LOGIC (Firestore) ----

  /// Checks if a username is already taken.
  Future<bool> isUsernameUnique(String username) async {
    try {
      final result = await firebaseFirestore
          .collection('users')
          .where('username', isEqualTo: username.trim().toLowerCase())
          .limit(1)
          .get();

      // ✅ Return true if no user found with this username
      return result.docs.isEmpty;
    } catch (e) {
      debugPrint("❌ Error checking username uniqueness: $e");
      // 🚨 Return false on any error to avoid accidental duplicates
      return false;
    }
  }

  /// Creates a user record in Firestore after successful registration.
  Future<void> createUserRecord({
    required String uid,
    required String firstname,
    required String lastname,
    required String username,
    required String email,
  }) async {
    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'uid': uid,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("✅ User record created in Firestore for $username");
    } catch (e) {
      debugPrint("❌ Failed to create Firestore user record: $e");
      rethrow;
    }
  }
}
