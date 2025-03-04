import 'package:vizinhanca_shop/data/models/announcement_address_model.dart';
import 'package:vizinhanca_shop/data/models/category_model.dart';

class CreateAnnouncementModel {
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final CategoryModel category;
  final AnnouncementAddressModel address;
  final double latitude;
  final double longitude;

  CreateAnnouncementModel({
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category.toJson(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
