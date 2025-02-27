class CategoryModel {
  final String name;
  final String id;

  CategoryModel({required this.name, required this.id});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(name: json['name'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }

  factory CategoryModel.empty() {
    return CategoryModel(name: '', id: '');
  }
}
