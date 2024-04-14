import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'view_facility.dart';
import 'src/locations.dart' as locations;
import 'package:http/http.dart' as http;

//main for debugging
void main() => runApp(const MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {
  final Map<String, Marker> _markers = {};
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
          print(weatherWarning);
        });
      } else {

        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('ERROR WEATHER');
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet:null,
            onTap: (){
              String locations = office.name;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewFacility(location: locations)),
              );
            },
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        body: 
        Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(1.290270, 103.851959),
                zoom: 11,
              ),
              markers: _markers.values.toSet(),
            ),
            if (weatherWarning != 'No weather warning')
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: 
                  Container(
                    color: const Color(0xFFFEFBEA),
                    padding: const EdgeInsets.all(13),
                    alignment: Alignment.center,
                    child: 
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.black,
                            size: 30,
                          ),
                          Text(weatherWarning,
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                  ),
              ),
          ],
        ),
      ),
    );
  }
}