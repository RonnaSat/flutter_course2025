import 'package:flutter/foundation.dart';
import '../model/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  Weather _currentWeather = Weather(
    location: 'New York',
    temperature: 22,
    condition: 'Sunny',
    humidity: 60,
    windSpeed: 5,
    visibility: 10,
  );

  Weather get currentWeather => _currentWeather;

  final Map<String, Weather> _mockWeatherData = {
    'new york': Weather(
      location: 'New York',
      temperature: 22,
      condition: 'Sunny',
      humidity: 60,
      windSpeed: 5,
      visibility: 10,
    ),
    'london': Weather(
      location: 'London',
      temperature: 15,
      condition: 'Rainy',
      humidity: 82,
      windSpeed: 7,
      visibility: 6,
    ),
    'tokyo': Weather(
      location: 'Tokyo',
      temperature: 27,
      condition: 'Partly Cloudy',
      humidity: 45,
      windSpeed: 3,
      visibility: 9,
    ),
    'paris': Weather(
      location: 'Paris',
      temperature: 18,
      condition: 'Cloudy',
      humidity: 70,
      windSpeed: 4,
      visibility: 8,
    ),
    'sydney': Weather(
      location: 'Sydney',
      temperature: 30,
      condition: 'Sunny',
      humidity: 50,
      windSpeed: 6,
      visibility: 15,
    ),
  };

  void updateWeather(String city) {
    final cityLower = city.toLowerCase();
    if (_mockWeatherData.containsKey(cityLower)) {
      _currentWeather = _mockWeatherData[cityLower]!;
    } else {
      // Generate random weather for cities not in our mock data
      _currentWeather = Weather(
        location: city,
        temperature: 15 + (DateTime.now().microsecond % 20),
        condition: [
          'Sunny',
          'Cloudy',
          'Rainy',
          'Partly Cloudy'
        ][DateTime.now().microsecond % 4],
        humidity: 40 + (DateTime.now().microsecond % 50),
        windSpeed: 2 + (DateTime.now().microsecond % 10),
        visibility: 5 + (DateTime.now().microsecond % 10),
      );
    }
    notifyListeners();
  }
}
