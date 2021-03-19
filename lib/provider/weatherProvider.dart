import 'package:feep_competition2021/main.dart';
import 'package:feep_competition2021/models/dailyWeather.dart';
import 'package:feep_competition2021/provider/locationService.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/weather.dart';

class ApiConfig {
  // URL example: https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=
  final apiKey = '';
  final baseUrl = 'api.openweathermap.org';
  final apiUrl = 'data/';
  final version = 2.5;
}

class WeatherRequestException implements Exception {
  final String message;
  const WeatherRequestException([this.message = '']);
}

class WeatherProvider with ChangeNotifier {
  final config = ApiConfig();

  /// Weather data.
  Weather weather;
  DailyWeather currentWeather;
  List<DailyWeather> hourlyWeather = [];
  List<DailyWeather> hourly24Weather = [];
  List<DailyWeather> fiveDayWeather = [];
  List<DailyWeather> sevenDayWeather = [];

  /// Weathe Request using current [lat] [lng].
  Future<Map<String, dynamic>> _fetchWeatherByLatLng(
      double lat, double lng) async {
    final path = '${this.config.apiUrl}${this.config.version}/weather';
    final Uri uri = Uri.https(this.config.baseUrl, path, {
      'lat': lat.toString(),
      'lon': lng.toString(),
      'units': 'metric',
      'appid': this.config.apiKey
    });
    logger.d(uri);
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw error;
    }
  }

  /// Weather Request by [location].
  Future<Map<String, dynamic>> _fetchWeatherByLocation(String location) async {
    final path = '${this.config.apiUrl}${this.config.version}/weather';
    final Uri uri = Uri.https(this.config.baseUrl, path,
        {'q': location, 'units': 'metric', 'appid': this.config.apiKey});
    logger.d(uri);
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw error;
    }
  }

  /// Daily Request using current [lat] [lng].
  Future<Map<String, dynamic>> _fetchDailyByLatLng(
      double lat, double lng) async {
    final path = '${this.config.apiUrl}${this.config.version}/onecall';
    final Uri uri = Uri.https(this.config.baseUrl, path, {
      'lat': lat.toString(),
      'lon': lng.toString(),
      'units': 'metric',
      'exclude': 'minutely,current',
      'appid': this.config.apiKey
    });
    logger.d(uri);
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw error;
    }
  }

  /// Get weather data based on current gps location or using query [location].
  Future<void> getWeatherData({
    bool useCurrentLocation = true,
    String location,
  }) async {
    double lat, lng;
    if (useCurrentLocation) {
      if (!await LocationService.isServiceAvailable()) {
        throw LocationServiceException('Service not available');
      } else {
        logger.d('Searcing by current gps location.');
        final myLocation = await LocationService.myLocation();
        lat = myLocation.latitude;
        lng = myLocation.longitude;
      }
    }

    // weather data.
    try {
      final json = (useCurrentLocation)
          ? await this._fetchWeatherByLatLng(lat, lng)
          : await this._fetchWeatherByLocation(location);
      this.weather = Weather.fromJson(json);
    } catch (error) {
      logger.e(error);
      throw WeatherRequestException(error.toString());
    }

    // daily data.
    try {
      final dailyData =
          await this._fetchDailyByLatLng(this.weather.lat, this.weather.long);
      this.currentWeather = DailyWeather.fromJson(dailyData);
      final List items = dailyData['daily'];
      final List itemsHourly = dailyData['hourly'];
      hourly24Weather = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .skip(1)
          .take(24)
          .toList();
      hourlyWeather = hourly24Weather.sublist(0, 3);
      sevenDayWeather = items
          .map((item) => DailyWeather.fromDailyJson(item))
          .skip(1)
          .take(7)
          .toList();
    } catch (error) {
      logger.e(error);
      throw WeatherRequestException(error.toString());
    }
    notifyListeners();
  }
}
