import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../theme/app_theme.dart';
import '../utils/weather_helper.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({
    super.key,
    required this.days,
    required this.onRefresh,
  });

  final List<DailyForecast> days;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Perkiraan ${days.length} Hari',
            style: textTheme.titleLarge?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  for (var i = 0; i < days.length; i++)
                    _ForecastRow(day: days[i], index: i),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.day, required this.index});

  final DailyForecast day;
  final int index;

  String get _label {
    if (index == 0) return 'Hari ini';
    if (index == 1) return 'Besok';
    return WeatherHelper.shortDate(day.date);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              _label,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            WeatherHelper.icon(day.weatherCode),
            size: 26,
            color: WeatherHelper.iconColor(day.weatherCode, onDark: false),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WeatherHelper.describe(day.weatherCode),
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Hujan ${day.rainProbability}%',
                  style: textTheme.labelSmall?.copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
          Text(
            '${day.maxTemp.round()}° ',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '/ ${day.minTemp.round()}°',
            style: textTheme.bodyMedium?.copyWith(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}