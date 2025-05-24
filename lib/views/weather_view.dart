import 'package:flutter/material.dart';
import 'package:test_flutter/models/weather_model.dart';
import 'package:test_flutter/viewModels/weather_view_model.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final weatherViewModel = WeatherViewModel();

  @override
  void initState() {
    super.initState();
    weatherViewModel.addListener(() {
      setState(() {});
    });

    weatherViewModel.fetchAllData();
  }

  @override
  void dispose() {
    weatherViewModel.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return weatherViewModel.isLoading ? _loadingComponent() : _mainComponent();
  }

  Widget _mainComponent() {
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _weather(weather: weatherViewModel.currentWeather!),
                    IconButton(
                        onPressed: () {
                          weatherViewModel.fetchAllData();
                        },
                        icon: Icon(Icons.refresh, color: Colors.white)),
                  ],
                ),
              ),
              SafeArea(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherViewModel.weathers.length,
                    itemBuilder: (context, index) {
                      final weather = weatherViewModel.weathers[index];
                      return _weatherCard(weather: weather);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingComponent() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 2,
      ),
    );
  }

  Widget _weatherCard({required Weather weather}) {
    return Card(
      child: _weather(weather: weather, textColor: Colors.black),
    );
  }

  Widget _weather({required Weather weather, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(weather.city,
                style: TextStyle(color: textColor ?? Colors.white)),
            Text(weather.condition,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: textColor ?? Colors.white)),
            Text(weather.temperature.toString(),
                style: TextStyle(color: textColor ?? Colors.white)),
            Image.network(
              weather.iconUrl,
              width: 32,
              height: 32,
            ),
            Text(weather.formattedDate,
                style: TextStyle(color: textColor ?? Colors.white)),
            Text(weather.formattedTime,
                style: TextStyle(color: textColor ?? Colors.white)),
          ],
        ),
      ),
    );
  }
}
