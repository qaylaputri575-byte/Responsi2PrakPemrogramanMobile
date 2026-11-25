import 'package:flutter/material.dart';

import '../models/weather_model.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.current, required this.today});

  final CurrentWeather current;
  final DailyForecast today;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                _Stat(label: 'Kelembapan', value: '${current.humidity}%'),
                const VerticalDivider(color: Colors.white24, width: 1),
                _Stat(
                  label: 'Angin',
                  value: '${current.windSpeed.round()} km/h',
                ),
                const VerticalDivider(color: Colors.white24, width: 1),
                _Stat(
                  label: 'Peluang Hujan',
                  value: '${today.rainProbability}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Terasa seperti ${current.apparentTemperature.round()}°  •  Curah hujan ${current.precipitation} mm',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
