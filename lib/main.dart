import 'package:flutter/material.dart';
import 'package:wetter_app/weather_service.dart';

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
    _temperature = WeatherService.fetchCurrentTemperature();
  }

  void _refreshTemperature() {
    setState(() {
      _temperature = WeatherService.fetchCurrentTemperature();
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
                    Text('Berlin:'),
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
