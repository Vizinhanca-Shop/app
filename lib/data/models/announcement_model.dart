import 'package:vizinhanca_shop/data/models/user_model.dart';

class AnnouncementModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final UserModel seller;
  final String category;
  final String address;

  AnnouncementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.seller,
    required this.category,
    required this.address,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['images']),
      seller: UserModel.fromJson(json['seller']),
      category: json['category'],
      address: json['address'],
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
      'address': address,
    };
  }

  factory AnnouncementModel.empty() {
    return AnnouncementModel(
      id: '',
      name: '',
      description: '',
      price: 0.0,
      images: [],
      seller: UserModel.empty(),
      category: '',
      address: '',
    );
  }
}
