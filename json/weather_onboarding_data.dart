class WeatherOnboardingData {
  String title, description, image;

  WeatherOnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<WeatherOnboardingData> weather = [
  WeatherOnboardingData(
    title: "Real-Time Weather",
    description:
        "Get live updates for your current location anywhere, anytime.",
    image: "assets/images/weather/onboarding_1.jpg",
  ),
  WeatherOnboardingData(
    title: "Dettailed Forecasts",
    description: "Hourly & 3-day forecasts to help you plan ahead.",
    image: "assets/images/weather/onboarding_2.jpg",
  ),
  WeatherOnboardingData(
    title: "Stay Alert, Stay Safe",
    description:
        "Get severe weather alerts and stay prepared for what's coming.",
    image: "assets/images/weather/onboarding_3.jpg",
  ),
];
