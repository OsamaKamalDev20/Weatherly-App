// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:firebase_project/Weather%20App/json/weather_onboarding_data.dart';
import 'package:firebase_project/Weather%20App/navigation/weather_navigation.dart';
import 'package:firebase_project/Weather%20App/provider/weather_onboarding_screen_provider.dart';
import 'package:firebase_project/Weather%20App/widgets/weather_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../themes/weather_colors.dart';

class WeatherOnboardingScreen extends StatefulWidget {
  const WeatherOnboardingScreen({super.key});

  @override
  State<WeatherOnboardingScreen> createState() =>
      _WeatherOnboardingScreenState();
}

class _WeatherOnboardingScreenState extends State<WeatherOnboardingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    context.read<WeatherOnboardingScreenProvider>().initializeAnimations(this);
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
    return Consumer<WeatherOnboardingScreenProvider>(
      builder: ((context, provider, _) {
        final isLastPage = provider.currentPage == weather.length - 1;
        return Scaffold(
          backgroundColor: scaffoldColor,
          body: SafeArea(
            child: Column(
              children: [
                // 🔹 Skip Button Row
                Padding(
                  padding: const .only(right: 14),
                  child: Align(
                    alignment: .topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WeatherNavigation(),
                          ),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: .w500,
                          color: weatherPrimColor,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: provider.weatherController,
                    itemCount: weather.length,
                    onPageChanged: provider.onPageChanged,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const .symmetric(horizontal: 24),
                        child: FadeTransition(
                          opacity: provider.fadeAnimation,
                          child: SlideTransition(
                            position: provider.slideAnimation,
                            child: Column(
                              spacing: 15,
                              mainAxisAlignment: .center,
                              children: [
                                // Animated image container
                                Container(
                                  width: .infinity,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: .circular(6),
                                    border: .all(
                                      color: weatherBorderColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ScaleTransition(
                                    scale: provider.scaleAnimation,
                                    child: Hero(
                                      tag: "books_${weather[index].image}",
                                      child: ClipRRect(
                                        borderRadius: .circular(10),
                                        child: Stack(
                                          fit: .expand,
                                          children: [
                                            Image.asset(
                                              weather[index].image,
                                              fit: .cover,
                                            ),

                                            // 🔹 Dark overlay — image
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: .topCenter,
                                                  end: .bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    scaffoldColor.withOpacity(
                                                      .15,
                                                    ),
                                                    secondaryBackground
                                                        .withOpacity(.65),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Title with animated container
                                FadeInLeft(
                                  delay: const Duration(milliseconds: 1200),
                                  child: Text(
                                    weather[index].title,
                                    textAlign: .center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: .bold,
                                      color: primaryText,
                                    ),
                                  ),
                                ),

                                // Description with animated container
                                FadeInUp(
                                  delay: const Duration(milliseconds: 1200),
                                  child: Text(
                                    weather[index].description,
                                    textAlign: .center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: secondaryText,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Page indicator
                const SizedBox(height: 20),
                FadeInLeft(
                  delay: const Duration(milliseconds: 1000),
                  child: SmoothPageIndicator(
                    controller: provider.weatherController,
                    count: weather.length,
                    effect: CustomizableEffect(
                      dotDecoration: DotDecoration(
                        width: 15,
                        height: 15,
                        color: weatherSecondColor.withOpacity(.3),
                        borderRadius: .circular(50),
                      ),
                      activeDotDecoration: DotDecoration(
                        width: 40,
                        height: 8,
                        color: weatherPrimColor,
                        borderRadius: .circular(50),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                FadeInLeft(
                  delay: const Duration(milliseconds: 1000),
                  child: WeatherGradientButton(
                    text: isLastPage ? "Get Started" : "Next",
                    onPressed: () {
                      HapticFeedback.lightImpact();

                      if (isLastPage) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WeatherNavigation(),
                          ),
                        );
                      } else {
                        provider.nextPage(weather.length);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
