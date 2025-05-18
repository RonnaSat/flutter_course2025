class Weather {
  final String city;
  final String condition;
  final double temperature;
  final DateTime date;
  final String icon;

  const Weather({
    required this.city,
    required this.condition,
    required this.temperature,
    required this.date,
    required this.icon,
  });
  get formattedDate {
    return "${date.day}/${date.month}/${date.year}";
  }

  get formattedTime {
    twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(date.hour)}:${twoDigits(date.minute)}";
  }

  get formattedTempString {
    return "${temperature.toStringAsFixed(1)} °F";
  }

  get iconUrl {
    return 'https://openweathermap.org/img/w/$icon.png';
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      date: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
        isUtc: false,
      ),
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }

  static List<Weather> fromForecastJson(Map<String, dynamic> json) {
    return (json['list'] as List).map<Weather>((item) {
      return Weather(
        date: DateTime.fromMillisecondsSinceEpoch(
          item['dt'] * 1000,
          isUtc: false,
        ),
        city: json['city']['name'],
        temperature: item['main']['temp'].toDouble(),
        condition: item['weather'][0]['main'],
        icon: item['weather'][0]['icon'],
      );
    }).toList();
  }
}
