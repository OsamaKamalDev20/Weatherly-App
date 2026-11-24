// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:firebase_project/Weather%20App/screens/weather_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../themes/weather_colors.dart';

class WeatherSplashScreen extends StatefulWidget {
  const WeatherSplashScreen({super.key});

  @override
  State<WeatherSplashScreen> createState() => _WeatherSplashScreenState();
}

class _WeatherSplashScreenState extends State<WeatherSplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WeatherOnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        width: .infinity,
        height: .infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [secondaryBackground, scaffoldColor],
          ),
        ),
        child: Stack(
          children: [
            // Background image with overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                      "assets/images/weather/splash_screen.jpg",
                    ),
                    fit: .cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6),
                      .darken,
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: Padding(
                padding: const .symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // App logo/icon
                    const SizedBox(height: 60),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: .circle,
                        boxShadow: [
                          BoxShadow(
                            color: cyanAccent.withOpacity(.35),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/weather/splash_icon.png",
                        width: 110,
                        height: 110,
                        fit: .contain,
                      ),
                    ),

                    // Main heading
                    const SizedBox(height: 30),
                    Text(
                      "Weatherly",
                      textAlign: .center,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 40,
                        fontWeight: .w700,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 24,
                            color: weatherPrimColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),

                    // Subtitle heading
                    const SizedBox(height: 20),
                    Text(
                      "Your Weather. \n Your Way.",
                      textAlign: .center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: .w500,
                        color: primaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Spacer(),
                    SpinKitFadingCircle(color: weatherPrimColor, size: 60.0),
                    const SizedBox(height: 20),
                    Text(
                      "Loading weather......",
                      textAlign: .center,
                      style: TextStyle(
                        fontSize: 20,
                        color: secondaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
