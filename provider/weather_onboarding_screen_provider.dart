import 'package:flutter/material.dart';

class WeatherOnboardingScreenProvider extends ChangeNotifier {
  int currentPage = 0;

  final PageController weatherController = PageController();

  late AnimationController _animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  void initializeAnimations(TickerProvider vsync) {
    currentPage = 0;

    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage(int length) {
    if (currentPage < length - 1) {
      weatherController.nextPage(
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    weatherController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
