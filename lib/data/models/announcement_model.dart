import 'package:intl/intl.dart' as intl;
import 'package:vizinhanca_shop/data/models/announcement_address_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';

class AnnouncementModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final UserModel seller;
  final CategoryModel category;
  final AnnouncementAddressModel address;

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
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['images']),
      seller: UserModel.fromJson(json['seller']),
      category: CategoryModel.fromJson(json['category']),
      address: AnnouncementAddressModel.fromJson(json['address']),
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
      'category': category.toJson(),
      'address': address,
    };
  }

  factory AnnouncementModel.empty() {
    return AnnouncementModel(
      id: '',
      name: '',
      description: '',
      price: 0,
      images: [],
      seller: UserModel.empty(),
      category: CategoryModel(id: '', name: ''),
      address: AnnouncementAddressModel.empty(),
    );
  }

  String formattedPrice() {
    return intl.NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(price / 100);
  }
}
