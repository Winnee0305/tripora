import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;

  // final String name;
  final String email;
  final String firstname;
  final String lastname;
  final String username;
  // final String? avatarUrl;
  // final String? bio;
  final DateTime createdAt;
  // final Map<String, dynamic>? preferences;

  UserData({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    // this.avatarUrl,
    // this.bio,
    required this.createdAt,
    // this.preferences,
  });

  // ---- Factory from Firestore ----
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserData(
      uid: doc.id,
      email: data['email'] ?? '',
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      username: data['username'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // avatarUrl: data['avatarUrl'],
      // bio: data['bio'],
      // joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // preferences: data['preferences'] != null
      //     ? Map<String, dynamic>.from(data['preferences'])
      //     : null,
    );
  }

  // ---- To Firestore ----
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
      // 'avatarUrl': avatarUrl,
      // 'bio': bio,
      // 'joinedAt': Timestamp.fromDate(joinedAt),
      // 'preferences': preferences,
    };
  }

  // ---- Clone/Copy helper ----
  UserData copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    DateTime? joinedAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserData(
      uid: uid,
      firstname: firstname,
      lastname: lastname,
      email: email ?? this.email,
      username: username,
      createdAt: createdAt,
      // avatarUrl: avatarUrl ?? this.avatarUrl,
      // bio: bio ?? this.bio,
      // joinedAt: joinedAt ?? this.joinedAt,
      // preferences: preferences ?? this.preferences,
    );
  }
}
