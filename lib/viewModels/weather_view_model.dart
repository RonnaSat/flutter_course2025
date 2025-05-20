import 'package:flutter/material.dart';
import 'package:test_flutter/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Weather> _weathers = [];
  Weather? _currentWeather;
  List<Weather> get weathers => List.unmodifiable(_weathers);

  Weather? get currentWeather => _currentWeather;
  String get _apiKey => dotenv.env['WEATHER_KEY'] ?? '';

  Future<void> fetchWeatherData() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?q=Bangkok&appid=$_apiKey',
    );
    if (response.statusCode == 200) {
      final data = response.data;
      final weather = Weather.fromJson(data);
      _currentWeather = weather;
    } else {
      throw Exception('Failed to load weather data');
    }
    notifyListeners();
  }

  Future<void> fetchForcastData() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/forecast?q=Bangkok&appid=$_apiKey',
    );
    if (response.statusCode == 200) {
      final data = response.data;
      final weathers = Weather.fromForecastJson(data);
      _weathers = weathers;
    } else {
      throw Exception('Failed to load weather data');
    }
    notifyListeners();
  }

  void fetchAllData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchWeatherData(),
      fetchForcastData(),
    ]);

    _isLoading = false;
    notifyListeners();
  }
}
