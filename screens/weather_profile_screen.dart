// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../themes/weather_colors.dart';

class WeatherProfileScreen extends StatelessWidget {
  const WeatherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        actions: [
          Container(
            margin: .symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: weatherCardColor,
              border: .all(width: 1.5, color: weatherBorderColor),
              shape: .circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: primaryText),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 30),
              weatherProfileImage(),
              const SizedBox(height: 16),
              weatherProfileInfo(),
              const SizedBox(height: 20),
              Container(
                margin: const .symmetric(horizontal: 15),
                padding: const .symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: weatherCardColor,
                  borderRadius: .circular(12),
                  border: .all(width: 1.5, color: weatherBorderColor),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _buildWeatherItems(
                      icon: Icons.location_on_outlined,
                      title: "My Location",
                      subTitle: "Manage saved locations",
                      color: weatherSecondColor,
                    ),
                    Divider(height: 1, color: weatherBorderColor),
                    _buildWeatherItems(
                      icon: CupertinoIcons.thermometer,
                      title: "Units",
                      subTitle: "°C, km/h, mm, kph, mb",
                      color: weatherSecondColor,
                    ),
                    Divider(height: 1, color: weatherBorderColor),
                    _buildWeatherItems(
                      icon: CupertinoIcons.bell,
                      title: "Notifications",
                      subTitle: "Manage notification settings",
                      color: weatherSecondColor,
                    ),
                    Divider(height: 1, color: weatherBorderColor),
                    _buildWeatherItems(
                      icon: Icons.warning_rounded,
                      title: "Weathher Alerts",
                      subTitle: "Severe weather updates",
                      color: errorColor,
                    ),
                    Divider(height: 1, color: weatherBorderColor),
                    _buildWeatherItems(
                      icon: Icons.language_rounded,
                      title: "App Language",
                      subTitle: "English",
                      color: weatherSecondColor,
                    ),
                    Divider(height: 1, color: weatherBorderColor),
                    _buildWeatherItems(
                      icon: Icons.lock_outline_rounded,
                      title: "Prvacy Policy",
                      color: weatherSecondColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Center weatherProfileInfo() {
    return Center(
      child: Column(
        children: [
          Text(
            "Osama Kamal",
            textAlign: .center,
            style: TextStyle(
              fontWeight: .bold,
              color: primaryText,
              fontSize: 24,
            ),
          ),
          Text(
            "osamakamal650@gmail.com",
            style: TextStyle(color: secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Center weatherProfileImage() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: .circle,
          boxShadow: [
            BoxShadow(
              color: weatherPrimColor.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 65,
          backgroundImage: AssetImage("assets/images/profile.png"),
        ),
      ),
    );
  }

  Widget _buildWeatherItems({
    required IconData icon,
    required String title,
    String? subTitle,
    required Color color,
  }) {
    return Padding(
      padding: const .symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const .all(10),
            decoration: BoxDecoration(
              color: weatherCardColor,
              border: .all(width: 1.5, color: weatherBorderColor),
              shape: .circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w600,
                    color: primaryText,
                  ),
                ),
                if (subTitle != null)
                  Text(
                    subTitle,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20, color: mutedText),
        ],
      ),
    );
  }
}
