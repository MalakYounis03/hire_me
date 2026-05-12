class CompanyJobModel {
  final String id;
  final String title;
  final String location;
  final String salary;
  final String jobType;
  final String workMode;
  final String status;
  final DateTime? createdAt;
  final String mainFieldName;
  final int applicantCount;

  CompanyJobModel({
    required this.id,
    required this.title,
    required this.location,
    this.salary = '',
    this.jobType = '',
    this.workMode = '',
    this.status = 'Open',
    this.createdAt,
    this.mainFieldName = '',
    this.applicantCount = 0,
  });

  factory CompanyJobModel.fromMap(String id, Map<String, dynamic> map) {
    return CompanyJobModel(
      id: id,
      title: map['title'] as String? ?? '',
      location: map['location'] as String? ?? '',
      salary: map['salary'] as String? ?? '',
      jobType: map['jobType'] as String? ?? '',
      workMode: map['workMode'] as String? ?? '',
      status: map['status'] as String? ?? 'Open',
      mainFieldName: map['mainFieldName'] as String? ?? '',
      createdAt: (map['createdAt'] as dynamic)?.toDate(),
    );
  }

  String get datePosted {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  String get jobTypeLabel {
    switch (jobType) {
      case 'FullTime':
        return 'Full Time';
      case 'PartTime':
        return 'Part Time';
      default:
        return jobType;
    }
  }
}
