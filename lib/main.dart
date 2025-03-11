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
  double? _savedTemperature; // Variable für die gespeicherte Temperatur

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
      setState(() {
        _savedTemperature =
            savedTemperature; // Setze die gespeicherte Temperatur
      });
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
      _savedTemperature =
          newTemperature; // Setze die neue gespeicherte Temperatur
      _temperature =
          Future.value(newTemperature); // Setze die neue aktuelle Temperatur
    });
  }

  // Lösche die gespeicherte Historie aus den SharedPreferences
  void _deleteHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('temperature'); // Löschen der gespeicherten Temperatur
    setState(() {
      _savedTemperature = null; // Lösche die gespeicherte Temperatur aus der UI
      _temperature = WeatherService
          .fetchCurrentTemperature(); // Hole die aktuelle Temperatur
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
                    if (_savedTemperature != null)
                      Text('Gespeicherte Temperatur: $_savedTemperature°C'),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _refreshTemperature,
                      child: const Text('Aktualisieren'),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _deleteHistory,
                      child: const Text('Historie Löschen'),
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
