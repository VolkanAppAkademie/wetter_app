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
        appBar: AppBar(title: const Text('Weather')),
        body: Center(
          child: FutureBuilder(
            future: WeatherService.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> data = snapshot.data as List<String>;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Text(data[index]);
                  },
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
