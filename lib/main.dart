import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/storage_service.dart';
import 'services/weather_service.dart';
import 'theme/app_theme.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(WeatherService(), StorageService())..init(),
      child: MaterialApp(
        title: 'Weather Forecast',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
