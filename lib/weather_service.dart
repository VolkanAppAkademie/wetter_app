/*import 'dart:convert';
import 'package:http/http.dart';

class WeatherService {
  static Future<List<double>> fetchData() async {
    const uriString =
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m';
    final response = await get(Uri.parse(uriString));
    final forecast = json.decode(response.body);
    print(forecast[
        'latitude']); //Zugriff auf den Wert vom Schlüssel latitude -> double
    print(forecast[
        'hourly_units']); //Zugriff auf den Wert vom Schlüssel hourly_units -> Map<String, String>
    //Zugriff auf den Wert vom Schlüssel temperature_2m von der Map die zu hourly_units gehört-> String
    print(forecast['hourly_units']['temperature_2m']);
    print(forecast[
        "hourly"]); //Zugriff auf den Wert vom Schlüssel hourly -> Map<String, List<dynamic>>
    print(forecast["hourly"]
        ["time"]); //Zugriff auf den Wert vom Schlüssel time -> List<String>
    // Zugriff auf den ersten Wert in der Liste die zum Schlüssel time gehört
    print(forecast["hourly"]["time"][0]);
    // aus ieinem Grund muss man noch die Daten abschreiben bevor man sie returnen kann,
    //deswegen machen wir das in den folgenden Zeilen mit einer for-Schleife

    List<double> hourlyTemperature = [];

    for (var timeStamp in forecast['hourly_units']['temperature_2m']) {
      hourlyTemperature.add(timeStamp);
    }
    return hourlyTemperature;
  }
}
*/
import 'dart:convert';
import 'package:http/http.dart';

class WeatherService {
  static Future<double> fetchCurrentTemperature() async {
    const uriString =
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m';
    final response = await get(Uri.parse(uriString));

    if (response.statusCode == 200) {
      final forecast = json.decode(response.body);

      // Zugriff auf die Temperaturdaten
      List<dynamic> temperatureData = forecast['hourly']['temperature_2m'];

      // Rückgabe der aktuellen Temperatur (erste Stunde)
      return temperatureData[0].toDouble();
    } else {
      throw Exception('Fehler beim Abrufen der Wetterdaten');
    }
  }
}
