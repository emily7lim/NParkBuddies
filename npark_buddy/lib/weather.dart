import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String weatherWarning = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherWarning();
  }

  Future<void> fetchWeatherWarning() async {
    var url = Uri.parse('https://hookworm-solid-tahr.ngrok-free.app/weather');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {

          weatherWarning = jsonDecode(response.body)['message'];
        });
      } else {

        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('ERROR WEATHER');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          if (weatherWarning != 'No weather warning')
            Container(
              color: Colors.red,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(weatherWarning,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
