class Job {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String category;
  final String type;
  final String logoUrl;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.category,
    required this.type,
    required this.logoUrl,
  });

  factory Job.fromMap(String id, Map<String, dynamic> data) {
    return Job(
      id: id,
      title: data['title'] ?? '',
      companyName: data['companyName'] ?? '',
      location: data['location'] ?? 'غزة، فلسطين',
      salary: data['salary'] ?? '0',
      category: data['category'] ?? 'General',
      type: data['type'] ?? 'Full-time',
      logoUrl: data['logoUrl'] ?? '',
    );
  }
}
