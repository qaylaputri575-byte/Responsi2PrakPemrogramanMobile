import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../services/geocoding_service.dart';
import '../utils/weather_helper.dart';
import 'view_status.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._geocodingService);

  final GeocodingService _geocodingService;
  Timer? _debounce;
  String _query = '';

  ViewStatus status = ViewStatus.initial;
  String errorMessage = '';
  List<LocationModel> results = [];

  void onQueryChanged(String value) {
    _query = value.trim();
    _debounce?.cancel();

    if (_query.length < 2) {
      results = [];
      status = ViewStatus.initial;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(_query);
    });
  }

  Future<void> search(String query) async {
    _query = query;
    status = ViewStatus.loading;
    notifyListeners();

    try {
      final data = await _geocodingService.searchCity(query);
      if (query != _query) return;
      results = data;
      status = data.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      if (query != _query) return;
      errorMessage = WeatherHelper.errorText(e);
      status = ViewStatus.error;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
