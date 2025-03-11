import 'package:flutter/material.dart';
import 'package:wetter_app/stadt.dart';
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
      return WeatherService.fetchCurrentTemperature(
          _selectedItem?.latitude ?? "52",
          _selectedItem?.longitude ?? "19",
          "temperature_2m"); // Abrufen der aktuellen Temperatur
    }
  }

  // Aktualisiere die Temperatur und speichere sie in den SharedPreferences
  void _refreshTemperature() async {
    double newTemperature = await WeatherService.fetchCurrentTemperature(
        _selectedItem?.latitude ?? "52",
        _selectedItem?.longitude ?? "19",
        "temperature_2m");
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
      _temperature = WeatherService.fetchCurrentTemperature(
          _selectedItem?.latitude ?? "52",
          _selectedItem?.longitude ?? "19",
          "temperature_2m"); // Hole die aktuelle Temperatur
    });
  }

// Die Liste der Dropdown-Elemente
  final List<Stadt> _items = [
    Stadt(latitude: "51.607", longitude: "13.3124", name: "München"),
    Stadt(latitude: "48.7823", longitude: "9.177", name: "Stuttgart"),
    Stadt(latitude: "53.5507", longitude: "9.993", name: "Hamburg"),
    Stadt(latitude: "48.7823", longitude: "9.177", name: "Stuttgart"),
  ];

  // Das aktuell ausgewählte Element
  Stadt? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Wetter App')),
        body: Center(
          child: FutureBuilder<double>(
            future: _temperature,
            builder: (context, index) {
              if (index.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<Stadt>(
                      value: _selectedItem,
                      hint: Text('Stadt'),
                      onChanged: (Stadt? newValue) {
                        setState(() {
                          _selectedItem = newValue;
                        });
                        print(
                            "newValue ${newValue?.latitude},${newValue?.longitude}${newValue?.name}");
                      },
                      items: _items.map<DropdownMenuItem<Stadt>>((Stadt value) {
                        return DropdownMenuItem<Stadt>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                    Text(_selectedItem?.name ?? ""),
                    Text('Aktuelle Temperatur: ${index.data}°C'),
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
              } else if (index.hasError) {
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
