/// User profile model for Firestore storage.
class UserProfile {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert UserProfile to Firestore document.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create UserProfile from Firestore document.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      photoURL: map['photoURL'] as String?,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: (map['updatedAt'] as dynamic).toDate(),
    );
  }

  /// Create a copy of UserProfile with modified fields.
  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
