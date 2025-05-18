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

    weatherViewModel.fetchForcastData();
    weatherViewModel.fetchWeatherData();
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
    return Center(
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    weatherViewModel.currentWeather?.city ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  Text(
                    weatherViewModel.currentWeather?.condition ?? "",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    weatherViewModel.currentWeather?.formattedTempString ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  if (weatherViewModel.currentWeather != null)
                    Image.network(
                      weatherViewModel.currentWeather?.iconUrl,
                      width: 48,
                      height: 48,
                    )
                  else
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.cloud_queue,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  Text(
                    weatherViewModel.currentWeather?.formattedDate ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  Text(
                    weatherViewModel.currentWeather?.formattedTime ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        weatherViewModel.fetchForcastData();
                        weatherViewModel.fetchWeatherData();
                      },
                      icon: Icon(Icons.refresh, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: weatherViewModel.weathers
                        .map((weather) => WeatherCard(
                              weather: weather,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(weather.city),
              Text(weather.condition,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(weather.temperature.toString()),
              Image.network(
                weather.iconUrl,
                width: 32,
                height: 32,
              ),
              Text(weather.formattedDate),
              Text(weather.formattedTime),
            ],
          ),
        ),
      ),
    );
  }
}
