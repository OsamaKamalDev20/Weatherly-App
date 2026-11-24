import 'package:firebase_project/Weather%20App/themes/weather_colors.dart';
import 'package:firebase_project/Weather%20App/widgets/weather_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';

/// Bottom sheet ko apni khud ki StatefulWidget banaya gaya hai taake
/// TextEditingController ka lifecycle Flutter khud sahi waqt pe handle kare.
class WeatherCitySelectionSheet extends StatefulWidget {
  const WeatherCitySelectionSheet({super.key});
  @override
  State<WeatherCitySelectionSheet> createState() =>
      _WeatherCitySelectionSheetState();
}

class _WeatherCitySelectionSheetState extends State<WeatherCitySelectionSheet> {
  final TextEditingController _cityController = TextEditingController();
  bool _isSubmitting = false;
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit(WeatherProvider provider, String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorColor,
          content: const Text("Please enter a city name"),
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await provider.fetchWeather(trimmed);
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorColor,
          content: Text(provider.errorMessage!),
        ),
      );
      return;
    }
    provider.clearCitySuggestions();
    if (mounted) Navigator.pop(context);
  }

  void _clearField(WeatherProvider provider) {
    _cityController.clear();
    provider.searchCity('');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    return Padding(
      padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.75,
        decoration: BoxDecoration(
          color: secondaryBackground,
          borderRadius: const .vertical(top: .circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: .stretch,
              children: [
                Center(
                  child: Container(
                    margin: const .only(top: 10, bottom: 6),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: weatherBorderColor,
                      borderRadius: .circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const .fromLTRB(20, 6, 8, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Enter Your City Name",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: .bold,
                            color: primaryText,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.clearCitySuggestions();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_rounded, color: secondaryText),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const .symmetric(horizontal: 20),
                  child: TextField(
                    cursorColor: weatherSecondColor,
                    controller: _cityController,
                    autofocus: true,
                    textInputAction: .search,
                    style: const TextStyle(color: primaryText),
                    onChanged: provider.searchCity,
                    onSubmitted: (value) => _submit(provider, value),
                    decoration: InputDecoration(
                      hintText: "Search city, e.g. Karachi",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: secondaryText,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: weatherPrimColor,
                      ),
                      suffixIcon: _cityController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                size: 20,
                                color: secondaryText,
                              ),
                              onPressed: () => _clearField(provider),
                            )
                          : null,
                      filled: true,
                      fillColor: scaffoldColor,
                      contentPadding: const .symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: .circular(12),
                        borderSide: BorderSide(
                          width: 1,
                          color: weatherSecondColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: .circular(12),
                        borderSide: BorderSide(
                          width: 1,
                          color: weatherSecondColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: .circular(12),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: weatherSecondColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (provider.isSearchingCity) {
                        return Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: weatherPrimColor,
                            ),
                          ),
                        );
                      }
                      if (provider.citySuggestions.isEmpty) {
                        final hasQuery =
                            _cityController.text.trim().length >= 2;
                        return Center(
                          child: Padding(
                            padding: const .symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                Icon(
                                  hasQuery
                                      ? Icons.location_off_outlined
                                      : Icons.travel_explore,
                                  size: 42,
                                  color: secondaryText,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  hasQuery
                                      ? 'No city found for "${_cityController.text.trim()}"'
                                      : "Start typing to search for a city",
                                  textAlign: .center,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const .symmetric(horizontal: 12),
                        itemCount: provider.citySuggestions.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, color: weatherBorderColor),
                        itemBuilder: (context, index) {
                          final suggestion = provider.citySuggestions[index];
                          final cityName =
                              (suggestion["name"] ?? "Unknown city").toString();
                          final cityRegion = (suggestion["region"] ?? "")
                              .toString();
                          final cityCountry = (suggestion["country"] ?? "")
                              .toString();
                          final subtitleText = [
                            cityRegion,
                            cityCountry,
                          ].where((e) => e.isNotEmpty).join(", ");
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(10),
                            ),
                            contentPadding: const .symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            leading: Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: weatherPrimColor,
                            ),
                            title: Text(
                              cityName,
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: subtitleText.isEmpty
                                ? null
                                : Text(
                                    subtitleText,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: secondaryText,
                            ),
                            onTap: () => _submit(provider, cityName),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: _isSubmitting
                      ? Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: weatherPrimColor,
                            ),
                          ),
                        )
                      : WeatherGradientButton(
                          fontSize: 16,
                          text: "Submit",
                          onPressed: () =>
                              _submit(provider, _cityController.text),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
