import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';

class GeocodingService {
  Future<List<LocationModel>> searchCity(String query) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari kota (kode ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? [];

    return results
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
