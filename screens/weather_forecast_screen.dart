// ignore_for_file: strict_top_level_inference

import 'package:firebase_project/Weather%20App/helper/weather_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import '../themes/weather_colors.dart';

class WeatherForecastsScreen extends StatelessWidget {
  const WeatherForecastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecastDays =
        provider.weatherData?['forecast']?['forecastday'] as List<dynamic>?;
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryBackground,
        elevation: 0,
        title: Text(
          "📍${provider.weatherData?['location']?['name'] ?? ''} 3 days Forecast",
          style: TextStyle(fontSize: 18, fontWeight: .w600, color: primaryText),
        ),
      ),
      body: provider.isLoading || forecastDays == null
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: weatherPrimColor,
              ),
            )
          : SafeArea(
              child: ListView.builder(
                padding: const .symmetric(horizontal: 15, vertical: 10),
                itemCount: forecastDays.length,
                itemBuilder: (context, index) {
                  final day = forecastDays[index];
                  return Container(
                    padding: const .symmetric(horizontal: 15, vertical: 10),
                    margin: .only(bottom: 25),
                    decoration: BoxDecoration(
                      color: weatherCardColor,
                      borderRadius: .circular(10),
                      border: .all(color: weatherBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        cityWeatherForecastDate(day),
                        const SizedBox(height: 6),
                        cityForecastMaxMinTemperature(day),
                        const SizedBox(height: 35),
                        cityForecastDetailedCard(day),
                        const SizedBox(height: 25),
                        const Divider(
                          color: weatherBorderColor,
                          thickness: 1.5,
                        ),
                        cityForecastAstroDetails(day),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget cityForecastDetailedCard(dynamic day) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https:${day['day']?['condition']?['icon'] ?? ''}",
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                day['day']?['condition']?['text']?.toString() ?? '--',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 130,
            child: VerticalDivider(thickness: 1.5, color: weatherBorderColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              cityForecastDetails(
                CupertinoIcons.cloud_rain,
                "Precipitation",
                "${day['day']?['totalprecip_mm']?.toString() ?? '--'} mm",
                blueAccent,
              ),
              const SizedBox(height: 10),
              cityForecastDetails(
                CupertinoIcons.drop,
                "Humidity",
                "${day['day']?['avghumidity']?.toString() ?? '--'}%",
                cyanAccent,
              ),
              const SizedBox(height: 10),
              cityForecastDetails(
                CupertinoIcons.wind,
                "Max Wind",
                "${day['day']?['maxwind_mph']?.toString() ?? '--'} kph",
                weatherSecondColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cityForecastDetails(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(color: mutedText, fontSize: 13)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cityForecastMaxMinTemperature(dynamic day) {
    final maxTemp = day['day']?['maxtemp_c'];
    final minTemp = day['day']?['mintemp_c'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${maxTemp ?? '--'}°C",
          style: TextStyle(
            fontSize: 16,
            color: errorColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 20,
            child: VerticalDivider(thickness: 1.5, color: weatherBorderColor),
          ),
        ),

        Text(
          "${minTemp ?? '--'}°C",
          style: TextStyle(
            fontSize: 16,
            color: blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Align cityWeatherForecastDate(day) {
    return Align(
      alignment: .topLeft,
      child: Text(
        DateTimeHelper.formatDate(day['date']),
        style: TextStyle(fontSize: 15, color: primaryText, fontWeight: .w500),
      ),
    );
  }

  Widget cityForecastAstroDetails(dynamic day) {
    return Row(
      children: [
        Expanded(
          child: cityForecastAstroItem(
            CupertinoIcons.sunrise,
            "Sunrise",
            day['astro']?['sunrise']?.toString() ?? '--',
            warningColor,
          ),
        ),
        Expanded(
          child: cityForecastAstroItem(
            CupertinoIcons.sunset,
            "Sunset",
            day['astro']?['sunset']?.toString() ?? '--',
            warningColor,
          ),
        ),
        Expanded(
          child: cityForecastAstroItem(
            CupertinoIcons.sun_max,
            "UV Index",
            day['day']?['uv']?.toString() ?? '--',
            Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget cityForecastAstroItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 25, color: color),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(color: mutedText, fontSize: 13)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
