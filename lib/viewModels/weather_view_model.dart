import 'package:flutter/material.dart';
import 'package:test_flutter/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_flutter/utils/location_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Weather> _weathers = [];
  Weather? _currentWeather;
  List<Weather> get weathers => List.unmodifiable(_weathers);

  Weather? get currentWeather => _currentWeather;
  String get _apiKey => dotenv.env['WEATHER_KEY'] ?? '';

  Future<void> fetchWeatherData() async {
    final dio = Dio();
    final lat = _locationService.latitude ?? 13.7563;
    final lon = _locationService.longitude ?? 100.5018;

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey',
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
    if (!_locationService.hasLocation) {
      await _locationService.getCurrentLocation();
    }

    final dio = Dio();
    final lat = _locationService.latitude ?? 13.7563;
    final lon = _locationService.longitude ?? 100.5018;

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey',
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

    bool locationAcquired = await _locationService.getCurrentLocation();

    if (!locationAcquired) {
      print('Failed to acquire location.');
      if (_locationService.locationError != null) {
        print('Location Error: ${_locationService.locationError}');
      }
    } else {
      print(
          'Location acquired: Lat: ${_locationService.latitude}, Lon: ${_locationService.longitude}');
    }

    await Future.wait([
      fetchWeatherData(),
      fetchForcastData(),
    ]);

    _isLoading = false;
    notifyListeners();
  }
}
