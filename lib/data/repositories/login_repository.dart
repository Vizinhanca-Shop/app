import 'dart:convert';

import 'package:vizinhanca_shop/config/app_config.dart';
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class LoginRepository {
  final HttpClient client;
  final AppConfig appConfig;
  final LocalStorageService localStorageService;

  LoginRepository({
    required this.client,
    required this.appConfig,
    required this.localStorageService,
  });

  String get baseUrl => appConfig.baseUrl;

  Future<void> login(String accessToken) async {
    final url = Uri.parse('$baseUrl/api/auth/google-login');
    print(url);
    final body = {'access_token': accessToken};
    try {
      final response = await client.post(url, data: body);
      print(response.body);
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final token = decodedBody['token'];
        await localStorageService.setString('token', token);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }
}
