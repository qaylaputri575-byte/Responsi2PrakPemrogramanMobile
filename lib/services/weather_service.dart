import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(LocationModel location) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'current':
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'hourly': 'temperature_2m,weather_code',
      'daily':
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data cuaca (kode ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(data);
  }
}