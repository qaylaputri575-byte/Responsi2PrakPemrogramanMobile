import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../utils/weather_helper.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.current, required this.today});

  final CurrentWeather current;
  final DailyForecast today;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              WeatherHelper.icon(current.weatherCode),
              size: 96,
              color: WeatherHelper.iconColor(current.weatherCode),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${current.temperature.round()}°',
                  style: textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  WeatherHelper.describe(current.weatherCode),
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _Pill(
                label: 'Tertinggi',
                value: '${today.maxTemp.round()}°C',
                icon: Icons.arrow_upward_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Pill(
                label: 'Terendah',
                value: '${today.minTemp.round()}°C',
                icon: Icons.arrow_downward_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            '$label : $value',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
