import 'package:flutter/material.dart';
import 'package:wetter_app/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Future<double> _temperature;

  @override
  void initState() {
    super.initState();
    _temperature = _loadTemperature();
  }

  // Lade die gespeicherte Temperatur oder hole die aktuelle Temperatur
  Future<double> _loadTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTemperature = prefs.getDouble('temperature');
    if (savedTemperature != null) {
      return savedTemperature; // Rückgabe der gespeicherten Temperatur
    } else {
      return WeatherService
          .fetchCurrentTemperature(); // Abrufen der aktuellen Temperatur
    }
  }

  // Aktualisiere die Temperatur und speichere sie in den SharedPreferences
  void _refreshTemperature() async {
    double newTemperature = await WeatherService.fetchCurrentTemperature();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(
        'temperature', newTemperature); // Speichern der neuen Temperatur

    setState(() {
      _temperature = Future.value(newTemperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wetter App')),
        body: Center(
          child: FutureBuilder<double>(
            future: _temperature,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Berlin:'),
                    Text('Aktuelle Temperatur: ${snapshot.data}°C'),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _refreshTemperature,
                      child: const Text('Aktualisieren'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text("Fehler aufgetreten");
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
