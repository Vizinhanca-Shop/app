import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/models/announcement_model.dart';
import 'package:vizinhanca_shop/data/models/create_announcement_model.dart';
import 'package:vizinhanca_shop/data/models/filters_model.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';
import 'package:vizinhanca_shop/data/services/location_service.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class AnnouncementRepository {
  final HttpClient client;
  final AppConfig appConfig;
  final LocalStorageService localStorageService;
  final LocationService locationService;

  AnnouncementRepository({
    required this.client,
    required this.appConfig,
    required this.localStorageService,
    required this.locationService,
  });

  String get baseUrl => appConfig.baseUrl;

  Future<Map<String, dynamic>> fetchAnnouncements({
    int page = 1,
    int limit = 10,
    required FiltersModel filters,
    required String? latitude,
    required String? longitude,
  }) async {
    var url = Uri.parse('$baseUrl/api/announcements?page=$page&limit=$limit');

    final LocationData location = await locationService.getCurrentLocation();

    Map<String, String> queryParams = {
      'latitude': latitude ?? location.latitude.toString(),
      'longitude': longitude ?? location.longitude.toString(),
      'category': filters.category,
      'radius': filters.radius.toString(),
      'sortBy': filters.order == 'Mais recentes' ? 'createdAt' : 'distance',
      'search': filters.search ?? '',
    };

    url = url.replace(queryParameters: queryParams);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        List<AnnouncementModel> announcements = [];
        for (var item in decodedBody['announcements']) {
          announcements.add(AnnouncementModel.fromJson(item));
        }
        return {
          'announcements': announcements,
          'totalPages': decodedBody['totalPages'],
          'currentPage': decodedBody['currentPage'],
        };
      } else {
        return {'announcements': [], 'totalPages': 1, 'currentPage': page};
      }
    } catch (e) {
      return {'announcements': [], 'totalPages': 1, 'currentPage': page};
    }
  }

  Future<AnnouncementModel> fetchAnnouncement(String productId) async {
    final url = Uri.parse('$baseUrl/api/announcements/$productId');

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        return AnnouncementModel.fromJson(decodedBody);
      } else {
        return AnnouncementModel.empty();
      }
    } catch (e) {
      return AnnouncementModel.empty();
    }
  }

  Future<List<AnnouncementModel>> fetchUserAnnouncements() async {
    final token = await localStorageService.getString('token');
    final url = Uri.parse('$baseUrl/api/announcements/user/my-announcements');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.get(url, customHeaders: headers);
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        List<AnnouncementModel> announcements = [];
        for (var item in decodedBody) {
          announcements.add(AnnouncementModel.fromJson(item));
        }
        return announcements;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> createAnnouncement(CreateAnnouncementModel announcement) async {
    final token = await localStorageService.getString('token');

    final localImages =
        announcement.images.where((img) => !img.startsWith('http')).toList();

    List<http.MultipartFile> multipartFiles = [];
    for (final imagePath in localImages) {
      final multipartFile = await http.MultipartFile.fromPath(
        'images',
        imagePath,
      );
      multipartFiles.add(multipartFile);
    }

    Map<String, dynamic> fields = {
      'name': announcement.name,
      'description': announcement.description,
      'price': announcement.price.toString(),
      'category': announcement.category.id,
      'address[road]': announcement.address.road,
      'address[city]': announcement.address.city,
      'address[state]': announcement.address.state,
      'address[postalCode]': announcement.address.postalCode,
      'address[neighborhood]': announcement.address.neighborhood,
      'address[latitude]': announcement.address.latitude.toString(),
      'address[longitude]': announcement.address.longitude.toString(),
    };

    for (int i = 0; i < multipartFiles.length; i++) {
      fields['images[$i]'] = multipartFiles[i];
    }

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/api/announcements');
    final response = await client.multipart(
      url,
      data: fields,
      method: 'POST',
      customHeaders: headers,
    );

    if (response.statusCode == 201) {
      print('Anúncio criado com sucesso!');
    } else {
      print('Erro ao criar anúncio: ${response.statusCode}');
      throw Exception('Erro ao criar anúncio');
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    final token = await localStorageService.getString('token');

    final localImages =
        announcement.images.where((img) => !img.startsWith('http')).toList();
    final remoteImages =
        announcement.images.where((img) => img.startsWith('http')).toList();

    List<http.MultipartFile> multipartFiles = [];
    for (final imagePath in localImages) {
      final multipartFile = await http.MultipartFile.fromPath(
        'images',
        imagePath,
      );
      multipartFiles.add(multipartFile);
    }

    Map<String, dynamic> fields = {
      'name': announcement.name,
      'description': announcement.description,
      'price': announcement.price.toString(),
      'category': announcement.category.id,
      'remote_images': jsonEncode(remoteImages),
      'address[road]': announcement.address.road,
      'address[city]': announcement.address.city,
      'address[state]': announcement.address.state,
      'address[postalCode]': announcement.address.postalCode,
      'address[neighborhood]': announcement.address.neighborhood,
      'address[latitude]': announcement.address.latitude.toString(),
      'address[longitude]': announcement.address.longitude.toString(),
    };

    for (int i = 0; i < multipartFiles.length; i++) {
      fields['images[$i]'] = multipartFiles[i];
    }

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/api/announcements/${announcement.id}');
    final response = await client.multipart(
      url,
      data: fields,
      method: 'PUT',
      customHeaders: headers,
    );

    if (response.statusCode == 200) {
      print('Anúncio atualizado com sucesso!');
    } else {
      print('Erro ao atualizar anúncio: ${response.statusCode}');
      throw Exception('Erro ao atualizar anúncio');
    }
  }

  Future<void> deleteAnnouncement(String productId) async {
    final token = await localStorageService.getString('token');
    final url = Uri.parse('$baseUrl/api/announcements/$productId');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.delete(url, customHeaders: headers);

    if (response.statusCode == 200) {
      print('Anúncio deletado com sucesso!');
    } else {
      print('Erro ao deletar anúncio: ${response.statusCode}');
      throw Exception('Erro ao deletar anúncio');
    }
  }
}
