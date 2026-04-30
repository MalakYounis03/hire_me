class ApplicationListModel {
  final String id;
  final String name;
  final String jobTitle;
  final String location;
  final String appliedAt;
  final String avatarUrl;

  ApplicationListModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.location,
    required this.appliedAt,
    this.avatarUrl = '',
  });
}
