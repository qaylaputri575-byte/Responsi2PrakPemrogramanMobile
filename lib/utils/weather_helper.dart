import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class WeatherHelper {
  static String describe(int code) {
    if (code == 0) return 'Cerah';
    if (code == 1) return 'Cerah Berawan';
    if (code == 2) return 'Berawan Sebagian';
    if (code == 3) return 'Mendung';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 57) return 'Gerimis';
    if (code >= 61 && code <= 67) return 'Hujan';
    if (code >= 71 && code <= 77) return 'Salju';
    if (code >= 80 && code <= 82) return 'Hujan Deras';
    if (code == 85 || code == 86) return 'Hujan Salju';
    if (code >= 95) return 'Badai Petir';
    return 'Tidak Diketahui';
  }

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.blur_on_rounded;
    if (code >= 51 && code <= 57) return Icons.grain_rounded;
    if (code >= 61 && code <= 67) return Icons.water_drop_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.umbrella_rounded;
    if (code == 85 || code == 86) return Icons.ac_unit_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;
    return Icons.cloud_queue_rounded;
  }

  static Color iconColor(int code, {bool onDark = true}) {
    if (code == 0 || code == 1) return const Color(0xFFFFC107);
    return onDark ? Colors.white : const Color(0xFF5C6BC0);
  }

  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _shortDays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static String fullDate(DateTime d) {
    return '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  static String shortDate(DateTime d) {
    return '${_shortDays[d.weekday - 1]}, ${d.day} ${_shortMonths[d.month - 1]}';
  }

  static String errorText(Object error) {
    if (error is SocketException) {
      return 'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.';
    }
    if (error is TimeoutException) {
      return 'Permintaan terlalu lama. Silakan coba lagi.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}
