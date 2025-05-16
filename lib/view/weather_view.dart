import 'package:flutter/cupertino.dart';
import '../viewModel/weather_view_model.dart';
import '../model/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherViewModel _viewModel = WeatherViewModel();
  final TextEditingController _cityController =
      TextEditingController(text: 'New York');

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Weather'),
        border: null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _cityController,
                      placeholder: 'Enter city',
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      clearButtonMode: OverlayVisibilityMode.editing,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: const Icon(CupertinoIcons.search, size: 26),
                    onPressed: () {
                      setState(() {
                        _viewModel.updateWeather(_cityController.text);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _viewModel,
                builder: (context, _) {
                  final weather = _viewModel.currentWeather;
                  return Column(
                    children: [
                      Text(
                        weather.location,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        _getWeatherIcon(weather.condition),
                        size: 100,
                        color: CupertinoColors.systemBlue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${weather.temperature}°C',
                        style: const TextStyle(
                            fontSize: 42, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        weather.condition,
                        style: const TextStyle(
                            fontSize: 20, color: CupertinoColors.systemGrey),
                      ),
                      const SizedBox(height: 32),
                      _buildWeatherDetailsRow(weather),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsRow(Weather weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildWeatherDetail(
          CupertinoIcons.wind,
          'Wind',
          '${weather.windSpeed} km/h',
        ),
        _buildWeatherDetail(
          CupertinoIcons.drop,
          'Humidity',
          '${weather.humidity}%',
        ),
        _buildWeatherDetail(
          CupertinoIcons.eye,
          'Visibility',
          '${weather.visibility} km',
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: CupertinoColors.systemGrey),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: CupertinoColors.systemGrey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return CupertinoIcons.sun_max_fill;
      case 'partly cloudy':
        return CupertinoIcons.cloud_sun_fill;
      case 'cloudy':
        return CupertinoIcons.cloud_fill;
      case 'rainy':
        return CupertinoIcons.cloud_rain_fill;
      case 'thunderstorm':
        return CupertinoIcons.cloud_bolt_fill;
      case 'snowy':
        return CupertinoIcons.snow;
      default:
        return CupertinoIcons.cloud_fill;
    }
  }
}
