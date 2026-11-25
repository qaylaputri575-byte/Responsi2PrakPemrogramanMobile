import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_cities';
  static const String _lastLocationKey = 'last_location';
  static const String _recentsKey = 'recent_cities';

  Future<List<LocationModel>> loadFavorites() => _loadList(_favoritesKey);

  Future<void> saveFavorites(List<LocationModel> favorites) =>
      _saveList(_favoritesKey, favorites);

  Future<List<LocationModel>> loadRecents() => _loadList(_recentsKey);

  Future<void> saveRecents(List<LocationModel> recents) =>
      _saveList(_recentsKey, recents);

  Future<LocationModel?> loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastLocationKey);
    if (raw == null) return null;
    try {
      return LocationModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
  }

  Future<List<LocationModel>> _loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(key) ?? [];
    final result = <LocationModel>[];
    for (final item in raw) {
      try {
        result.add(
          LocationModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (_) {}
    }
    return result;
  }

  Future<void> _saveList(String key, List<LocationModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}