class CategoryModel {
  final String id;
  final String name;
  final String iconUrl; // رابط الصورة من الفايربيز

  CategoryModel({required this.id, required this.name, required this.iconUrl});

  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      iconUrl: data['icon'] ?? '', // تأكدي أن الحقل في فايربيز اسمه icon
    );
  }
}
