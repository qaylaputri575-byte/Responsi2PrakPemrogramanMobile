class LocationModel {
  final String name;
  final String? admin1;
  final String country;
  final double latitude;
  final double longitude;

  const LocationModel({
    required this.name,
    this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  static const LocationModel defaultCity = LocationModel(
    name: 'Semarang',
    admin1: 'Jawa Tengah',
    country: 'Indonesia',
    latitude: -6.9667,
    longitude: 110.4167,
  );

  String get id =>
      '${latitude.toStringAsFixed(3)},${longitude.toStringAsFixed(3)}';

  String get subtitle {
    final parts = <String>[
      if (admin1 != null && admin1!.isNotEmpty) admin1!,
      if (country.isNotEmpty) country,
    ];
    return parts.join(', ');
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String? ?? '',
      admin1: json['admin1'] as String?,
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'admin1': admin1,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
