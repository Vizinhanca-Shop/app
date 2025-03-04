import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HttpClient {
  Future<http.Response> get(Uri url, {Map<String, String>? customHeaders});
  Future<http.Response> post(
    Uri url, {
    dynamic data,
    Map<String, String>? customHeaders,
  });
  Future<dynamic> put(
    Uri url, {
    dynamic data,
    Map<String, String>? customHeaders,
  });
  Future<dynamic> patch(
    Uri url, {
    dynamic data,
    Map<String, String>? customHeaders,
  });
  Future<dynamic> delete(Uri url, {Map<String, String>? customHeaders});
  Future<dynamic> multipart(
    Uri url, {
    dynamic data,
    String method,
    Map<String, String>? customHeaders,
  });
}

class HttpClientImpl implements HttpClient {
  final client = http.Client();
  final headers = {'Content-Type': 'application/json'};

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? customHeaders}) {
    return client.get(url, headers: customHeaders ?? headers);
  }

  @override
  Future<http.Response> post(
    Uri url, {
    dynamic data,
    Map<String, String>? customHeaders,
  }) {
    return client.post(
      url,
      body: json.encode(data),
      headers: customHeaders ?? headers,
    );
  }

  @override
  Future put(Uri url, {dynamic data, Map<String, String>? customHeaders}) {
    return client.put(url, body: data, headers: customHeaders ?? headers);
  }

  @override
  Future patch(Uri url, {dynamic data, Map<String, String>? customHeaders}) {
    return client.patch(
      url,
      body: json.encode(data),
      headers: customHeaders ?? headers,
    );
  }

  @override
  Future delete(Uri url, {Map<String, String>? customHeaders}) {
    return client.delete(url, headers: customHeaders ?? headers);
  }

  @override
  Future multipart(
    Uri url, {
    dynamic data,
    String method = 'POST',
    Map<String, String>? customHeaders,
  }) async {
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

    final response = await request.send();
    return http.Response.fromStream(response);
  }
}

class ClientException implements Exception {
  final String message;

  ClientException(this.message);

  @override
  String toString() => message;
}
