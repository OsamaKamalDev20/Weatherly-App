import 'package:firebase_project/Weather%20App/themes/weather_colors.dart';
import 'package:firebase_project/Weather%20App/widgets/weather_city_suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/weather_helper.dart';
import '../provider/weather_provider.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});
  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: scaffoldColor,
          appBar: weatherAppbar(context, provider),
          body: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: weatherPrimColor,
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const .symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        currentDateTime(provider),
                        const SizedBox(height: 80),
                        currentCityWeather(provider),
                        const SizedBox(height: 40),
                        todayWeatherHighlights(provider),
                        const SizedBox(height: 20),
                        cityHourlyWeatherForecast(provider),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Container cityHourlyWeatherForecast(WeatherProvider provider) {
    final List<dynamic> todayHours =
        provider.weatherData?['forecast']?['forecastday']?[0]?['hour'] ?? [];
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: secondaryBackground,
        border: .all(width: 1, color: weatherBorderColor),
        borderRadius: .circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Hourly Forecast",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w600,
                  color: primaryText,
                ),
              ),
              Text(
                "View All",
                style: TextStyle(fontSize: 13.5, color: weatherSecondColor),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: todayHours.length,
              itemBuilder: ((context, index) {
                final hour = todayHours[index];
                final rawTime = hour['time'];
                final hourEpoch = hour['time_epoch'];
                final currentEpoch =
                    provider.weatherData?['location']?['localtime_epoch'];
                final isNow = DateTimeHelper.isCurrentHour(
                  hourEpoch,
                  currentEpoch,
                );
                return Container(
                  width: 80,
                  margin: .symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: isNow
                        ? LinearGradient(colors: weatherGradient)
                        : null,
                    color: isNow ? null : weatherCardColor,
                    borderRadius: .circular(6),
                    border: .all(
                      color: isNow ? Colors.transparent : weatherBorderColor,
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        isNow ? "Now" : DateTimeHelper.formatHourTime(rawTime),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isNow ? .w600 : .w400,
                          color: isNow ? primaryText : mutedText,
                        ),
                      ),
                      Image.network(
                        "https:${hour['condition']['icon'] ?? ''}",
                        height: 60,
                        fit: .cover,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${hour['temp_c']}°C",
                        style: TextStyle(
                          fontSize: isNow ? 16 : 14,
                          fontWeight: isNow ? .w600 : .w500,
                          color: isNow ? primaryText : secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Column todayWeatherHighlights(WeatherProvider provider) {
    return Column(
      children: [
        Container(
          padding: const .symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: secondaryBackground,
            border: .all(width: 1, color: weatherBorderColor),
            borderRadius: .circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "Today's Highlights",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: .w600,
                      color: primaryText,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(fontSize: 13.5, color: weatherSecondColor),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  weatherDetails(
                    provider,
                    CupertinoIcons.drop,
                    "Humidity",
                    "${provider.weatherData?['current']['humidity']}%",
                    cyanAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.wind,
                    "Wind",
                    "${provider.weatherData?['current']['wind_kph']} kph",
                    blueAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.gauge,
                    "Pressure",
                    "${provider.weatherData?['current']['pressure_mb']} mb",
                    weatherSecondColor,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.eye,
                    "Visibility",
                    "${provider.weatherData?['current']['vis_km']} km",
                    cyanAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.sun_max,
                    "UV Index",
                    "${provider.weatherData?['current']['uv']}",
                    warningColor,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.cloud,
                    "Cloud",
                    "${provider.weatherData?['current']['cloud']}%",
                    blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const .symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: secondaryBackground,
            border: .all(width: 1, color: weatherBorderColor),
            borderRadius: .circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "Today's Highlights",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: .w600,
                      color: primaryText,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(fontSize: 13.5, color: weatherSecondColor),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  weatherDetails(
                    provider,
                    CupertinoIcons.thermometer_sun,
                    "Max Temp",
                    "${provider.weatherData?['forecast']['forecastday'][0]['day']['maxtemp_c']}°C",
                    errorColor,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.thermometer_snowflake,
                    "Min Temp",
                    "${provider.weatherData?['forecast']['forecastday'][0]['day']['mintemp_c']}°C",
                    cyanAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.snow,
                    "Chances of Snow",
                    "${provider.weatherData?['current']['chance_of_snow']}%",
                    cyanAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.cloud_rain,
                    "Chances of Rain",
                    "${provider.weatherData?['current']['chance_of_rain']}%",
                    blueAccent,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.wind,
                    "Wind Gust",
                    "${provider.weatherData?['current']['gust_kph']} kph",
                    weatherSecondColor,
                  ),
                  weatherDetails(
                    provider,
                    CupertinoIcons.drop_fill,
                    "Dew Point",
                    "${provider.weatherData?['current']?['dewpoint_c']}°C",
                    blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget weatherDetails(
    WeatherProvider provider,
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const .all(8),
      decoration: BoxDecoration(
        color: weatherCardColor,
        borderRadius: .circular(10),
        border: .all(color: weatherBorderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(title, style: TextStyle(color: mutedText)),
                Text(
                  value,
                  style: TextStyle(color: primaryText, fontWeight: .w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row currentCityWeather(WeatherProvider provider) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 6,
      children: [
        Image.network(
          "https:${provider.weatherData?['current']?['condition']?['icon'] ?? ''}",
          height: 140,
          fit: .cover,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                "${provider.weatherData?['current']['temp_c']}°C",
                style: TextStyle(
                  color: primaryText,
                  fontSize: 44,
                  fontWeight: .w700,
                ),
              ),
              Text(
                "${provider.weatherData?['current']['condition']['text']}",
                textAlign: .center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 20,
                  letterSpacing: 1.1,
                  fontWeight: .w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Feels like ${provider.weatherData?['current']['feelslike_c']}°C",
                style: TextStyle(color: mutedText, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Align currentDateTime(WeatherProvider provider) {
    return Align(
      alignment: .center,
      child: Text(
        DateTimeHelper.formatDateTime(
          provider.weatherData?['location']?['localtime'],
        ),
        style: TextStyle(fontSize: 14, color: secondaryText, fontWeight: .w500),
      ),
    );
  }

  AppBar weatherAppbar(BuildContext context, WeatherProvider provider) {
    return AppBar(
      backgroundColor: scaffoldColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu_rounded, size: 30, color: primaryText),
      ),
      centerTitle: true,
      title: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showCitySelectionDialogue(context),
        child: Container(
          padding: const .symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: weatherCardColor,
            border: .all(width: 1, color: weatherBorderColor),
            borderRadius: .circular(20),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  "📍${provider.city}",
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: .bold,
                    color: primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: secondaryText,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const .only(right: 10),
          child: Badge(
            label: Text('6', style: TextStyle(fontWeight: .w600)),
            backgroundColor: weatherPrimColor,
            textColor: primaryText,
            child: Icon(
              Icons.notifications_outlined,
              size: 30,
              color: primaryText,
            ),
          ),
        ),
      ],
    );
  }

  void _showCitySelectionDialogue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WeatherCitySelectionSheet(),
    );
  }
}
