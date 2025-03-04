class FiltersModel {
  final double radius;
  final String order;
  final String category;

  FiltersModel({required this.radius, required this.order, this.category = ''});

  Map<String, dynamic> toJson() {
    return {'radius': radius, 'order': order, 'category': category};
  }

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      radius: json['radius'],
      order: json['order'],
      category: json['category'],
    );
  }

  factory FiltersModel.empty() {
    return FiltersModel(radius: 5, order: 'asc', category: '');
  }
}
