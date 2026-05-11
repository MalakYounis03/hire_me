class UserModel {
  final String uid;
  final String email;
  final String role;
  final String name;
  final String title;
  final String university;
  final String location;
  final String about;
  final String profileImage;
  final String coverImage; // ← جديد
  final List<EducationModel> education;
  final List<ExperienceModel> experience;
  final List<String> skills;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name = '',
    this.title = '',
    this.university = '',
    this.location = '',
    this.about = '',
    this.profileImage = '',
    this.coverImage = '', // ← جديد
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'jobseeker',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      university: map['university'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      profileImage: map['profileImage'] ?? '',
      coverImage: map['coverImage'] ?? '', // ← جديد
      education: (map['education'] as List<dynamic>? ?? [])
          .map((e) => EducationModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      experience: (map['experience'] as List<dynamic>? ?? [])
          .map((e) => ExperienceModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'title': title,
      'university': university,
      'location': location,
      'about': about,
      'profileImage': profileImage,
      'coverImage': coverImage, // ← جديد
      'education': education.map((e) => e.toMap()).toList(),
      'experience': experience.map((e) => e.toMap()).toList(),
      'skills': skills,
    };
  }

  UserModel copyWith({
    String? name,
    String? title,
    String? university,
    String? location,
    String? about,
    String? profileImage,
    String? coverImage, // ← جديد
    List<EducationModel>? education,
    List<ExperienceModel>? experience,
    List<String>? skills,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      role: role,
      name: name ?? this.name,
      title: title ?? this.title,
      university: university ?? this.university,
      location: location ?? this.location,
      about: about ?? this.about,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage, // ← جديد
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
    );
  }
}

// ─── Education Model ──────────────────────────────────────
class EducationModel {
  final String school;
  final String degree;
  final String field;
  final String startYear;
  final String endYear;

  EducationModel({
    required this.school,
    required this.degree,
    required this.field,
    required this.startYear,
    required this.endYear,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      school: map['school'] ?? '',
      degree: map['degree'] ?? '',
      field: map['field'] ?? '',
      startYear: map['startYear'] ?? '',
      endYear: map['endYear'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'school': school,
      'degree': degree,
      'field': field,
      'startYear': startYear,
      'endYear': endYear,
    };
  }
}

// ─── Experience Model ─────────────────────────────────────
class ExperienceModel {
  final String company;
  final String position;
  final String startDate;
  final String endDate;
  final String description;

  ExperienceModel({
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    return ExperienceModel(
      company: map['company'] ?? '',
      position: map['position'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}
