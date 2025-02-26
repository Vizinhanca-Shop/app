import 'package:vizinhanca_shop/data/models/user_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final UserModel seller;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.seller,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['images']),
      seller: UserModel.fromJson(json['seller']),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'seller': seller.toJson(),
      'category': category,
    };
  }

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      description: '',
      price: 0.0,
      images: [],
      seller: UserModel.empty(),
      category: '',
    );
  }
}
