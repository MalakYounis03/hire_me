class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type; // Full Time, Part Time, Remote
  final String salary;
  final String description;
  final String companyId;
  final DateTime? createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.description,
    required this.companyId,
    this.createdAt,
  });

  factory JobModel.fromMap(String id, Map<String, dynamic> map) {
    return JobModel(
      id: id,
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      salary: map['salary'] ?? '',
      description: map['description'] ?? '',
      companyId: map['companyId'] ?? '',
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'type': type,
      'salary': salary,
      'description': description,
      'companyId': companyId,
      'createdAt': createdAt,
    };
  }
}