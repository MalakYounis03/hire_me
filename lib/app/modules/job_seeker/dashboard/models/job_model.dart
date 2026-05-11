import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String companyId;
  final String companyName;
  final String mainFieldId;
  final String mainFieldName;
  final String title;
  final String description;
  final String requirements;
  final String jobType;
  final String workMode;
  final String status;
  final String location;
  final String salary;
  final String logoUrl;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.mainFieldId,
    required this.mainFieldName,
    required this.title,
    required this.description,
    required this.requirements,
    required this.jobType,
    required this.workMode,
    required this.status,
    required this.location,
    required this.salary,
    required this.logoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory JobModel.fromMap(String id, Map<String, dynamic> data) {
    return JobModel(
      id: id,
      companyId: data['companyId'] ?? '',
      companyName: data['companyName'] ?? '',
      mainFieldId: data['mainFieldId'] ?? '',
      mainFieldName: data['mainFieldName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      requirements: data['requirements'] ?? '',
      jobType: data['jobType'] ?? 'FullTime',
      workMode: data['workMode'] ?? 'Remote',
      status: data['status'] ?? 'Open',
      location: data['location'] ?? '',
      salary: data['salary'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
          : null,
      updatedAt: data['updatedAt'] is Timestamp
          ? data['updatedAt'] as Timestamp
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'mainFieldId': mainFieldId,
      'mainFieldName': mainFieldName,
      'title': title,
      'description': description,
      'requirements': requirements,
      'jobType': jobType,
      'workMode': workMode,
      'status': status,
      'location': location,
      'salary': salary,
      'logoUrl': logoUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get isOpen => status == 'Open';

  bool get isClosed => status == 'Closed';
}
