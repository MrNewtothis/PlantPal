import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static const String _apiKey =
      '9b6b6409694c5571cae3e002e3eb958c'; // Replace with your API key
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Returns true if it's currently raining in the given city
  static Future<bool> isRaining(String city) async {
    final url = '$_baseUrl?q=$city&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['weather'] != null) {
        for (var condition in data['weather']) {
          if (condition['main'].toString().toLowerCase().contains('rain')) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
