import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'btmNavBar.dart';
import 'select_datetime.dart';
import 'package:auto_size_text/auto_size_text.dart';

Future<Album> fetchAlbum(location) async {
  final response = await http
      .get(Uri.parse('https://hookworm-solid-tahr.ngrok-free.app/parks'));

  if (response.statusCode == 200) {
    int index = 0;
    for (int i = 0; i < jsonDecode(response.body).length; i++) {
      if (location == jsonDecode(response.body)[i].values.toList()[4]) {
        index = i;
      }
    }
    return Album.fromJson(
        jsonDecode(response.body)[index] as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final List<dynamic> facilities;
  final int id;
  final String name;

  const Album({
    required this.facilities,
    required this.id, //facility id
    required this.name,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      facilities: json['facilities'],
      id: json['id'],
      name: json['name'],
    );
  }
}

//main for debugging
void main() => runApp(MaterialApp(
      home: ViewFacility(
        location: '',
      ),
    ));

class ViewFacility extends StatefulWidget {
  final String location;

  ViewFacility({super.key, required this.location});
  @override
  State<ViewFacility> createState() => _ViewFacilityState(location: location);
}

class _ViewFacilityState extends State<ViewFacility> {
  late Future<Album> futureAlbum;
  final String location;

  @override
  _ViewFacilityState({required this.location});

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Image.asset(
                'assets/logo.png',
                height: 70,
                width: 70,
              ),
            ),
            const Text(
              'ParkBuddy',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Selected park is:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Facilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  String selectFacility;
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        for (int i = 0;
                            i < snapshot.data!.facilities.length;
                            i++) ...{
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFCF9F9E8),
                                side: const BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Container(
                                          width: 250,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                snapshot.data!.facilities[i],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              AutoSizeText(
                                                snapshot.data!.name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Transform.scale(
                                          alignment: Alignment.centerRight,
                                          scale: 0.6,
                                          child: IconButton(
                                            onPressed: () {
                                              selectFacility =
                                                  snapshot.data!.facilities[i];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectDateTime(
                                                            location: location, //park name
                                                            facility: //facility name
                                                                selectFacility)),
                                              );
                                            },
                                            icon: Image.asset(
                                                'assets/book_arrow.png'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        },
                      ],
                    );
                  } else if (snapshot.hasError) {
                    selectFacility = '';
                    return Text('${snapshot.error}');
                  }

                  selectFacility = '';
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
            FractionallySizedBox(
              child: Container(
                height: 100,
                alignment: Alignment.bottomCenter,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomNavigationBarExampleApp()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFCF9F9E8),
                      minimumSize: const Size(300, 50),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Image(
      //   image: AssetImage(),
      // ),
    );
  }
}
