import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vizinhanca_shop/data/services/local_storage_service.dart';

abstract class HttpClient {
  Future<http.Response> get(Uri url, {Map<String, String>? customHeaders});
  Future<http.Response> post(Uri url, {dynamic data, Map<String, String>? customHeaders});
  Future<dynamic> put(Uri url, {dynamic data});
  Future<dynamic> patch(Uri url, {dynamic data, Map<String, String>? customHeaders});
  Future<dynamic> delete(Uri url, {Map<String, String>? customHeaders});
  Future<dynamic> multipart(Uri url, {dynamic data, String method, Map<String, String>? customHeaders});
}

class HttpClientImpl implements HttpClient {
  final client = http.Client();
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();
  final headers = {'Content-Type': 'application/json'};

  Future<void> _refreshToken() async {
    final refreshUrl = Uri.parse('https://qa-helpets.plathanus.com.br/api/v1/auth/jwt/refresh');
    final refreshToken = await _getStoredRefreshToken();

    final response = await client.post(refreshUrl, body: json.encode({'refresh': refreshToken}), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      await _storeNewTokens(accessToken: data['access'], refreshToken: data['refresh']);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<http.Response> _performRequest(Future<http.Response> Function() requestFunction) async {
    try {
      final response = await requestFunction();

      if (response.statusCode == 401) {
        await _refreshToken();

        final token = await _getStoredAccessToken();

        headers['Authorization'] = 'Bearer $token';

        return requestFunction();
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? customHeaders}) {
    return _performRequest(() => client.get(url, headers: customHeaders ?? headers));
  }

  @override
  Future<http.Response> post(Uri url, {dynamic data, Map<String, String>? customHeaders}) {
    return _performRequest(() => client.post(url, body: json.encode(data), headers: customHeaders ?? headers));
  }

  @override
  Future put(Uri url, {dynamic data}) {
    return _performRequest(() => client.put(url, body: data, headers: headers));
  }

  @override
  Future patch(Uri url, {dynamic data, Map<String, String>? customHeaders}) {
    return _performRequest(() => client.patch(url, body: json.encode(data), headers: customHeaders ?? headers));
  }

  @override
  Future delete(Uri url, {Map<String, String>? customHeaders}) {
    return _performRequest(() => client.delete(url, headers: customHeaders ?? headers));
  }

  @override
  Future multipart(Uri url, {dynamic data, String method = 'POST', Map<String, String>? customHeaders}) async {
    final header = {'Content-Type': 'multipart/form-data'};
    var request = http.MultipartRequest(method, url);
    request.headers.addAll(customHeaders ?? header);
    data.forEach((key, value) {
      if (value is http.MultipartFile) {
        request.files.add(value);
      } else {
        request.fields[key] = value;
      }
    });

    return _performRequest(() async {
      final response = await request.send();
      return http.Response.fromStream(response);
    });
  }

  Future<String> _getStoredRefreshToken() async {
    final refreshToken = await _localStorageService.getString('refresh_token');
    return refreshToken ?? '';
  }

  Future<void> _storeNewTokens({required String accessToken, required String refreshToken}) async {
    await _localStorageService.setString('access_token', accessToken);
    await _localStorageService.setString('refresh_token', refreshToken);
  }

  Future<String> _getStoredAccessToken() async {
    final accessToken = await _localStorageService.getString('access_token');
    return accessToken ?? '';
  }
}

class ClientException implements Exception {
  final String message;

  ClientException(this.message);

  @override
  String toString() => message;
}
