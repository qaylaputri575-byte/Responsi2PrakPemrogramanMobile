import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../utils/weather_helper.dart';

class HourlyStrip extends StatelessWidget {
  const HourlyStrip({super.key, required this.hours});

  final List<HourlyForecast> hours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: Row(
        children: [
          for (var i = 0; i < hours.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _HourItem(item: hours[i], highlight: i == 0),
              ),
            ),
        ],
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  const _HourItem({required this.item, required this.highlight});

  final HourlyForecast item;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0x59FFFFFF) : const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.label,
            style: textTheme.labelSmall?.copyWith(
              color: highlight ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            WeatherHelper.icon(item.weatherCode),
            size: 22,
            color: WeatherHelper.iconColor(item.weatherCode),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.temperature.round()}°',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}