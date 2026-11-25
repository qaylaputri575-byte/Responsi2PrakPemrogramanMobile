import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/weather_helper.dart';
import 'view_status.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._weatherService, this._storageService);

  final WeatherService _weatherService;
  final StorageService _storageService;

  ViewStatus status = ViewStatus.initial;
  String errorMessage = '';
  WeatherModel? weather;
  LocationModel location = LocationModel.defaultCity;
  List<LocationModel> favorites = [];
  List<LocationModel> recents = [];

  /// Cuaca ringkas tiap kota favorit (key = LocationModel.id).
  final Map<String, WeatherModel> favoriteWeather = {};

  bool get isFavorite => isFavoriteLocation(location);

  bool isFavoriteLocation(LocationModel target) {
    return favorites.any((e) => e.id == target.id);
  }

  Future<void> init() async {
    favorites = await _storageService.loadFavorites();
    recents = await _storageService.loadRecents();
    final last = await _storageService.loadLastLocation();
    if (last != null) {
      location = last;
    }
    await loadWeather();
    // Sengaja tanpa await supaya home tidak menunggu cuaca favorit.
    loadFavoritesWeather();
  }

  Future<void> loadWeather({bool showLoading = true}) async {
    if (showLoading) {
      status = ViewStatus.loading;
      notifyListeners();
    }

    try {
      final result = await _weatherService.fetchWeather(location);
      weather = result;
      status = result.daily.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      errorMessage = WeatherHelper.errorText(e);
      status = ViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadFavoritesWeather() async {
    final missing =
        favorites.where((f) => !favoriteWeather.containsKey(f.id)).toList();
    if (missing.isEmpty) return;

    await Future.wait(
      missing.map((f) async {
        try {
          favoriteWeather[f.id] = await _weatherService.fetchWeather(f);
        } catch (_) {
          // Kartu tetap tampil dengan '--°' kalau request gagal.
        }
      }),
    );
    notifyListeners();
  }

  Future<void> selectLocation(LocationModel target) async {
    location = target;
    _storageService.saveLastLocation(target);

    recents = [
      target,
      ...recents.where((e) => e.id != target.id),
    ].take(5).toList();
    _storageService.saveRecents(recents);

    await loadWeather();
  }

  void removeRecent(LocationModel target) {
    recents = recents.where((e) => e.id != target.id).toList();
    notifyListeners();
    _storageService.saveRecents(recents);
  }

  Future<void> toggleFavorite(LocationModel target) async {
    if (isFavoriteLocation(target)) {
      favorites = favorites.where((e) => e.id != target.id).toList();
      favoriteWeather.remove(target.id);
    } else {
      favorites = [...favorites, target];
    }
    notifyListeners();
    await _storageService.saveFavorites(favorites);
    loadFavoritesWeather();
  }
}