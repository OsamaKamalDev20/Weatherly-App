import 'dart:async';
import 'package:firebase_project/Weather%20App/services/weather_services.dart';
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherServices _weatherServices = WeatherServices();
  String city = "Karachi";
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String? errorMessage;
  // City search
  List<dynamic> citySuggestions = [];
  bool isSearchingCity = false;
  Timer? _citySearchDebounce;
  int _searchRequestId = 0;

  Future<void> fetchWeather(String newCity) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      weatherData = await _weatherServices.fetchForecast(newCity);

      city = _toTitleCase(newCity);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  String _toTitleCase(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }

  void searchCity(String query) {
    final value = query.trim();
    _citySearchDebounce?.cancel();
    _searchRequestId++;
    if (value.length < 2) {
      citySuggestions = [];
      isSearchingCity = false;
      notifyListeners();
      return;
    }
    isSearchingCity = true;
    notifyListeners();
    final requestId = _searchRequestId;
    _citySearchDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final result = await _weatherServices.fetchCitySuggestion(value);
        // Ignore old request
        if (requestId != _searchRequestId) {
          return;
        }
        citySuggestions = result;
      } catch (e) {
        if (requestId != _searchRequestId) {
          return;
        }
        citySuggestions = [];
      } finally {
        if (requestId == _searchRequestId) {
          isSearchingCity = false;
          notifyListeners();
        }
      }
    });
  }

  void clearCitySuggestions() {
    _citySearchDebounce?.cancel();
    _searchRequestId++;
    citySuggestions = [];
    isSearchingCity = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _citySearchDebounce?.cancel();
    super.dispose();
  }
}
