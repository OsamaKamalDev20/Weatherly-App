// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/weather_helper.dart';
import '../provider/weather_provider.dart';
import '../themes/weather_colors.dart';

class WeatherAirQualityIndexScreen extends StatelessWidget {
  const WeatherAirQualityIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryBackground,
        elevation: 0,
        title: Text(
          "📍${provider.weatherData?['location']?['name'] ?? ''} Air Quality",
          style: TextStyle(fontSize: 18, fontWeight: .w600, color: primaryText),
        ),
      ),
      body: provider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: weatherPrimColor,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const .all(16),
                child: _airQualityCard(provider),
              ),
            ),
    );
  }

  Widget _airQualityCard(WeatherProvider provider) {
    final airQuality = AirQualityHelper.fromJson(
      provider.weatherData?['current']?['air_quality'],
    );
    final usEpa = airQuality.usEpa;
    final gbDefra = airQuality.gbDefra;
    final aqData = provider.weatherData?['current']?['air_quality'];

    return Column(
      crossAxisAlignment: .start,
      children: [
        // ── Header Card ───────────────────────────────────────
        _headerCard(usEpa),
        const SizedBox(height: 16),

        // ── Circular Pollutants (CO, NO₂, O₃, SO₂) ──────────
        _sectionLabel("Primary Pollutants"),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: .spaceAround,
          children: [
            _circularPollutant(
              "CO",
              _fmt(aqData?['co']),
              "μg/m³",
              const Color(0xFFEF5350),
            ),
            _circularPollutant(
              "NO₂",
              _fmt(aqData?['no2']),
              "μg/m³",
              const Color(0xFFFF9800),
            ),
            _circularPollutant(
              "O₃",
              _fmt(aqData?['o3']),
              "μg/m³",
              const Color(0xFF42A5F5),
            ),
            _circularPollutant(
              "SO₂",
              _fmt(aqData?['so2']),
              "μg/m³",
              const Color(0xFFAB47BC),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Particle Matter (PM2.5, PM10) ─────────────────────
        _sectionLabel("Particulate Matter"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _pmCard(
                "PM 2.5",
                _fmt(aqData?['pm2_5']),
                "Fine particles — penetrate deep into lungs",
                const Color(0xFF26C6DA),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _pmCard(
                "PM 10",
                _fmt(aqData?['pm10']),
                "Coarse particles — dust, pollen, mold",
                const Color(0xFF66BB6A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Index Cards ───────────────────────────────────────
        _sectionLabel("Air Quality Indexes"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _indexCard(
                "US EPA",
                "${aqData?['us-epa-index']}",
                usEpa.level,
                usEpa.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _indexCard(
                "UK DEFRA",
                "${aqData?['gb-defra-index']}",
                gbDefra.level,
                gbDefra.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Description ───────────────────────────────────────
        Container(
          width: .infinity,
          padding: const .all(14),
          decoration: BoxDecoration(
            color: usEpa.color.withOpacity(0.08),
            borderRadius: .circular(10),
            border: .all(color: usEpa.color.withOpacity(0.25)),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Icon(CupertinoIcons.info_circle, size: 25, color: usEpa.color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  usEpa.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: secondaryText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Header Card ───────────────────────────────────────────
  Widget _headerCard(AirQualityInfo info) {
    return Container(
      width: .infinity,
      padding: const .all(16),
      decoration: BoxDecoration(
        color: info.color.withOpacity(0.10),
        borderRadius: .circular(14),
        border: .all(color: info.color.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: info.color, shape: .circle),
            child: const Icon(
              CupertinoIcons.wind,
              color: primaryText,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Air Quality Index',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info.level,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: .bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info.range,
                  style: TextStyle(
                    fontSize: 15,
                    color: info.color,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Circular Pollutant Widget ──────────────────────────────
  Widget _circularPollutant(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: .circle,
            color: color.withOpacity(0.12),
            border: .all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: .bold,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(fontSize: 10, color: secondaryText),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: .w600,
            color: primaryText,
          ),
        ),
      ],
    );
  }

  // ── PM Card ────────────────────────────────────────────────
  Widget _pmCard(String label, String value, String description, Color color) {
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        color: weatherCardColor,
        borderRadius: .circular(10),
        border: Border.all(color: weatherBorderColor),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: .w600,
                  color: primaryText,
                ),
              ),
              Container(
                width: 12.5,
                height: 12.5,
                decoration: BoxDecoration(color: color, shape: .circle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "$value μg/m³",
            style: TextStyle(fontSize: 20, fontWeight: .bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: secondaryText, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ── Index Card ─────────────────────────────────────────────
  Widget _indexCard(String title, String value, String level, Color color) {
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: .circular(10),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: primaryText,
              fontWeight: .w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: .bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            level,
            style: TextStyle(fontSize: 14, fontWeight: .w600, color: color),
          ),
        ],
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: .w600, color: primaryText),
    );
  }

  // ── Safe format helper ─────────────────────────────────────
  String _fmt(dynamic value) {
    if (value == null) return '--';
    final d = double.tryParse(value.toString());
    if (d == null) return '--';
    return d >= 10 ? d.toStringAsFixed(0) : d.toStringAsFixed(1);
  }
}
