import 'package:firebase_project/Weather%20App/screens/weather_air_quality_index.dart';
import 'package:firebase_project/Weather%20App/screens/weather_forecast_screen.dart';
import 'package:firebase_project/Weather%20App/screens/weather_home_screen.dart';
import 'package:firebase_project/Weather%20App/screens/weather_profile_screen.dart';
import 'package:firebase_project/Weather%20App/themes/weather_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherNavigation extends StatefulWidget {
  const WeatherNavigation({super.key});
  @override
  State<WeatherNavigation> createState() => _WeatherNavigationState();
}

class _WeatherNavigationState extends State<WeatherNavigation> {
  int _selectedIndex = 0;
  final _screens = [
    WeatherHomeScreen(),
    WeatherForecastsScreen(),
    WeatherAirQualityIndexScreen(),
    WeatherProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: navBgColor),
        child: Padding(
          padding: const .all(8),
          child: Container(
            padding: const .symmetric(horizontal: 8),
            decoration: BoxDecoration(color: navBgColor),
            child: Row(
              mainAxisAlignment: .spaceAround,
              children: [
                _buildNavItem(
                  0,
                  CupertinoIcons.house,
                  CupertinoIcons.house_fill,
                  'Home',
                ),
                _buildNavItem(
                  1,
                  Icons.calendar_month_rounded,
                  Icons.calendar_month_outlined,
                  'Forecasts',
                ),
                _buildNavItem(2, Icons.air_outlined, Icons.air_outlined, 'AQI'),
                _buildNavItem(
                  3,
                  CupertinoIcons.person,
                  CupertinoIcons.person_fill,
                  'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() {
        _selectedIndex = index;
      }),
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: weatherCardColor,
                border: .all(width: 1, color: weatherBorderColor),
                borderRadius: .circular(6),
              )
            : null,
        child: Column(
          spacing: 4,
          mainAxisSize: .min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? activeIcon : inActiveIcon,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? .w600 : .w400,
                color: isSelected ? activeIcon : inActiveIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
