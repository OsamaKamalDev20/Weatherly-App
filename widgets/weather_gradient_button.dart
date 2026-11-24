// ignore_for_file: deprecated_member_use

import 'package:firebase_project/Cosmetic%20App/utils/colors.dart';
import 'package:flutter/material.dart';

import '../themes/weather_colors.dart';

class WeatherGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradient;
  final double? width;
  final int? fontSize;
  final double height;
  const WeatherGradientButton({
    required this.text,
    required this.onPressed,
    this.gradient = primaryGradient,
    this.width,
    this.height = 56,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(horizontal: 24),
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: weatherGradient,
          begin: .centerLeft,
          end: .centerRight,
        ),
        borderRadius: .circular(50),
        boxShadow: [
          BoxShadow(
            color: weatherGradient.first.withOpacity(.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: .circular(10)),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: .w600,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
    );
  }
}
