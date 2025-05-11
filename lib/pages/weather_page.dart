import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('8c82728e5ab2107f979769b6e2c861f8');
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'fog':
        return 'assets/cloudy.json';
      case 'haze':
        return 'assets/haze.json';
      case 'smoke':
      case 'sunny':
        return 'assets/sunny.json';
      case 'rain':
      case 'drizzle':
      case 'shower':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ??"loading.. city"),

            // animate
            Lottie.asset('assets/cloudy.json'),

            Text(_weather?.temperature.round().toString() ?? "loading temperature.."),

            Text(_weather?.mainCondition ?? "")

          ],
        ),
      ),
    );
  }
}