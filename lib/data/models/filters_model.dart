class FiltersModel {
  final double radius;
  final String order;
  final String category;
  final String? search;

  FiltersModel({
    required this.radius,
    required this.order,
    this.category = '',
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      'radius': radius,
      'order': order,
      'category': category,
      'search': search,
    };
  }

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      radius: json['radius'],
      order: json['order'],
      category: json['category'],
      search: json['search'],
    );
  }

  factory FiltersModel.empty() {
    return FiltersModel(radius: 5, order: 'asc', category: '', search: '');
  }
}
