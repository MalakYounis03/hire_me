class UserModel {
  final String uid;
  final String email;
  final String role; 
  final String? name;
  final String? phone;
  final String? profileImage;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    this.profileImage,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'jobseeker',
      name: map['name'],
      phone: map['phone'],
      profileImage: map['profileImage'],
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }
}