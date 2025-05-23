import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'TU_CLAVE_API'; // Reemplaza con tu clave API
  static const String baseUrl =
      'http://api.openweathermap.org/data/2.5/forecast';

  static Future<Map<String, dynamic>> getWeatherForecast(
    String location,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$location&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
