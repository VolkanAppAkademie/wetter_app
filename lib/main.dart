import 'package:flutter/material.dart';
import 'package:wetter_app/weather_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wetter App')),
        body: Center(
          child: FutureBuilder<double>(
            future: WeatherService.fetchCurrentTemperature(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Aktuelle Temperatur: ${snapshot.data}°C'),
                    const SizedBox(
                        height: 20), // Abstand zwischen Text und Button
                    TextButton(
                      onPressed: () {
                        // Hier kannst du die Aktion definieren, z. B. die Wetterdaten erneut abrufen
                        print("Button gedrückt");
                      },
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
