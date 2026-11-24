import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(String rawDateTime) {
    final dateTime = DateTime.parse(rawDateTime);
    return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dateTime);
  }

  // Hourly forecast ke liye — "2026-08-19 09:00" -> "9 AM"
  static String formatHourTime(String rawTime) {
    final dateTime = DateTime.parse(rawTime);
    return DateFormat('h a').format(dateTime);
  }

  // 3-day forecast ke liye — "2026-08-19" -> "Wed, Aug 19"
  static String formatDate(String rawDate) {
    final date = DateTime.parse(rawDate);
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  // Current hour check — highlight ke liye
  static bool isCurrentHour(int? hourEpoch, int? currentEpoch) {
    if (hourEpoch == null || currentEpoch == null) {
      return false;
    }

    return currentEpoch >= hourEpoch && currentEpoch < hourEpoch + 3600;
  }
}

class AirQualityInfo {
  final String level;
  final String range;
  final String description;
  final Color color;

  const AirQualityInfo({
    required this.level,
    required this.range,
    required this.description,
    required this.color,
  });
}

class AirQualityHelper {
  // ---------------------------------------------------------------------
  // US EPA Index  ("us-epa-index")  — scale 1-6
  // ---------------------------------------------------------------------
  static const Map<int, AirQualityInfo> _usEpaMap = {
    1: AirQualityInfo(
      level: 'Good',
      range: '0–50',
      description:
          'Air quality is satisfactory; pollution poses little or no risk.',
      color: Color(0xFF4CAF50), // Green
    ),
    2: AirQualityInfo(
      level: 'Moderate',
      range: '51–100',
      description:
          'Air quality is acceptable, though sensitive individuals may face minor risks.',
      color: Color(0xFFFFEB3B), // Yellow
    ),
    3: AirQualityInfo(
      level: 'Unhealthy for Sensitive Groups',
      range: '101–150',
      description:
          'Sensitive groups (children, older adults, asthma patients) may experience health effects.',
      color: Color(0xFFFF9800), // Orange
    ),
    4: AirQualityInfo(
      level: 'Unhealthy',
      range: '151–200',
      description:
          'General public may experience health effects; sensitive groups may face serious issues.',
      color: Color(0xFFF44336), // Red
    ),
    5: AirQualityInfo(
      level: 'Very Unhealthy',
      range: '201–300',
      description:
          'Health alert; increased risk of health effects for everyone.',
      color: Color(0xFF9C27B0), // Purple
    ),
    6: AirQualityInfo(
      level: 'Hazardous',
      range: '301+',
      description:
          'Emergency conditions; the entire population is likely to be affected.',
      color: Color(0xFF7E0023), // Maroon
    ),
  };

  static const AirQualityInfo _unknown = AirQualityInfo(
    level: 'Unknown',
    range: '-',
    description: 'No air quality data available.',
    color: Colors.grey,
  );

  /// `us-epa-index` (1-6) ko readable info mein convert karta hai.
  static AirQualityInfo getUsEpaInfo(int? index) {
    if (index == null) return _unknown;
    return _usEpaMap[index] ?? _unknown;
  }

  // ---------------------------------------------------------------------
  // UK DEFRA Index  ("gb-defra-index")  — scale 1-10
  // ---------------------------------------------------------------------
  /// `gb-defra-index` (1-10) ko readable info mein convert karta hai.
  static AirQualityInfo getGbDefraInfo(int? index) {
    if (index == null) return _unknown;

    if (index >= 1 && index <= 3) {
      return const AirQualityInfo(
        level: 'Low',
        range: '1–3',
        description: 'Air pollution poses little or no risk to health.',
        color: Color(0xFF4CAF50), // Green
      );
    } else if (index >= 4 && index <= 6) {
      return const AirQualityInfo(
        level: 'Moderate',
        range: '4–6',
        description:
            'Generally safe, but sensitive individuals may notice mild symptoms.',
        color: Color(0xFFFFC107), // Yellow/Orange
      );
    } else if (index >= 7 && index <= 9) {
      return const AirQualityInfo(
        level: 'High',
        range: '7–9',
        description:
            'Sensitive groups should reduce outdoor exertion; general public may notice mild effects.',
        color: Color(0xFFF44336), // Red
      );
    } else if (index == 10) {
      return const AirQualityInfo(
        level: 'Very High',
        range: '10',
        description: 'Everyone should reduce outdoor physical exertion.',
        color: Color(0xFF7E0023), // Maroon
      );
    }
    return _unknown;
  }

  static ({AirQualityInfo usEpa, AirQualityInfo gbDefra}) fromJson(
    Map<String, dynamic>? airQualityJson,
  ) {
    if (airQualityJson == null) {
      return (usEpa: _unknown, gbDefra: _unknown);
    }

    final usEpaIndex = (airQualityJson['us-epa-index'] as num?)?.toInt();
    final gbDefraIndex = (airQualityJson['gb-defra-index'] as num?)?.toInt();

    return (
      usEpa: getUsEpaInfo(usEpaIndex),
      gbDefra: getGbDefraInfo(gbDefraIndex),
    );
  }
}
