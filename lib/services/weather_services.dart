import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minimal_weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{

  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future <Weather> getWeather(String cityName) async {

    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future <String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();

    // Get Permission from User
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    
    // If permission is still denied after request or permanently denied
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      throw Exception('Location permission denied');
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert Location --> List of placemark object
    List <Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Get City Name from first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }

}