import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/models/user_model.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class ProfileRepository {
  final HttpClient client;
  final AppConfig appConfig;
  final LocalStorageService localStorageService;

  ProfileRepository({
    required this.client,
    required this.appConfig,
    required this.localStorageService,
  });

  String get baseUrl => appConfig.baseUrl;

  Future<UserModel> fetchUserById({required String userId}) async {
    final url = Uri.parse('$baseUrl/api/users/me');
    final token = await localStorageService.getString('token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(url, customHeaders: headers);
    final decodedBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(decodedBody);
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<UserModel> updateUser({
    required String name,
    required String phone,
    String? avatar,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/me');
    final token = await localStorageService.getString('token');

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    http.MultipartFile? file;

    if (avatar != null && avatar.isNotEmpty) {
      file = await http.MultipartFile.fromPath('avatar', avatar);
    }

    final data = {
      'name': name,
      'phone': phone,
      ...avatar != null ? {'avatar': file} : {},
    };

    final response = await client.multipart(
      url,
      method: 'PUT',
      data: data,
      customHeaders: headers,
    );

    if (response.statusCode == 200) {
      final decodedBody = json.decode(response.body);
      return UserModel.fromJson(decodedBody);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> deleteUser() async {
    final url = Uri.parse('$baseUrl/api/users/me');
    final token = await localStorageService.getString('token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.delete(url, customHeaders: headers);

    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
