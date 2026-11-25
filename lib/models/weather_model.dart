class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final double precipitation;
  final double windSpeed;
  final int humidity;
  final int weatherCode;

  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.precipitation,
    required this.windSpeed,
    required this.humidity,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final int rainProbability;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.rainProbability,
  });
}

class HourlyForecast {
  final String label;
  final double temperature;
  final int weatherCode;

  const HourlyForecast({
    required this.label,
    required this.temperature,
    required this.weatherCode,
  });
}

class WeatherModel {
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final List<HourlyForecast> hourly;

  const WeatherModel({
    required this.current,
    required this.daily,
    this.hourly = const [],
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    final times = (dailyJson['time'] as List?) ?? [];
    final maxTemps = dailyJson['temperature_2m_max'] as List;
    final minTemps = dailyJson['temperature_2m_min'] as List;
    final codes = dailyJson['weather_code'] as List;
    final rain = dailyJson['precipitation_probability_max'] as List;

    final days = <DailyForecast>[];
    for (var i = 0; i < times.length; i++) {
      days.add(
        DailyForecast(
          date: DateTime.parse(times[i] as String),
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weatherCode: (codes[i] as num).toInt(),
          rainProbability: (rain[i] as num?)?.toInt() ?? 0,
        ),
      );
    }

    final hours = <HourlyForecast>[];
    final hourlyJson = json['hourly'] as Map<String, dynamic>?;
    if (hourlyJson != null) {
      final hTimes = (hourlyJson['time'] as List?) ?? [];
      final hTemps = (hourlyJson['temperature_2m'] as List?) ?? [];
      final hCodes = (hourlyJson['weather_code'] as List?) ?? [];
      final currentTime = (currentJson['time'] as String?) ?? '';
      final nowKey =
      currentTime.length >= 13 ? currentTime.substring(0, 13) : '';
      var start = hTimes.indexWhere((t) => (t as String).startsWith(nowKey));
      if (start < 0) start = 0;

      for (var i = start;
      i < hTimes.length &&
          i < start + 6 &&
          i < hTemps.length &&
          i < hCodes.length;
      i++) {
        final time = hTimes[i] as String;
        hours.add(
          HourlyForecast(
            label: i == start ? 'Now' : time.substring(11, 16),
            temperature: (hTemps[i] as num).toDouble(),
            weatherCode: (hCodes[i] as num).toInt(),
          ),
        );
      }
    }

    return WeatherModel(
      current: CurrentWeather.fromJson(currentJson),
      daily: days,
      hourly: hours,
    );
  }
}