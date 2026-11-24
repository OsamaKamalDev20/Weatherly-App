import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WeatherServices {
  final String weatherAPIKey = "14ff0b16859648a68f691602242303";
  final String forecastBaseUrl = "https://api.weatherapi.com/v1/forecast.json";
  final String searchCityUrl = "https://api.weatherapi.com/v1/search.json";
  Future<Map<String, dynamic>> fetchForecast(
    String city, {
    int days = 3,
  }) async {
    try {
      final url =
          '$forecastBaseUrl?key=$weatherAPIKey&q=$city&days=$days&aqi=yes';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        final message =
            data["error"]?["message"] ?? "Failed to load weather data";
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

  Future<List<dynamic>> fetchCitySuggestion(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      final url = "$searchCityUrl?key=$weatherAPIKey&q=$query";
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // FIX: safe type-check, warna Map aane par crash hota tha
        if (decoded is List) {
          return decoded;
        }
        return [];
      }
      return [];
    } on SocketException {
      return [];
    } catch (e) {
      return [];
    }
  }
}
