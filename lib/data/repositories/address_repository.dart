import 'dart:convert';
import 'package:vizinhanca_shop/data/models/address_model.dart';
import 'package:vizinhanca_shop/http/http_client.dart';

class AddressRepository {
  final HttpClient client;

  AddressRepository({required this.client});

  Future<List<AddressModel>> fetchSuggestions(String query) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5",
    );

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<AddressModel> suggestions = [];

        for (final suggestion in decodedBody) {
          suggestions.add(AddressModel.fromJson(suggestion));
        }

        return suggestions;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&q=$address',
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        return {
          'latitude': double.parse(data[0]['lat']),
          'longitude': double.parse(data[0]['lon']),
        };
      }
    }

    return null;
  }

  Future<Map<String, dynamic>> fetchAddressFromCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null && data['erro'] != true) {
        return data;
      }
    }

    return {};
  }
}
