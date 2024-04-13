import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:npark_buddy/btmNavBar.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: selectFacility(),
    ));

class Facility {
  final int id;
  final String name;
  final String type;
  final double avgRating;
  final int numRatings;
  final String park;

  Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.avgRating,
    required this.numRatings, 
    required this.park,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      park: json['park'],
      avgRating: json['avg_rating'].toDouble(),
      numRatings: json['num_ratings'],
    );
  }
}

class selectFacility extends StatefulWidget {

  selectFacility({Key? key}) : super(key: key);

  @override
  State<selectFacility> createState() => _selectFacilityState();
}

class _selectFacilityState extends State<selectFacility> {
  late Future<List<Facility>> futureFacilities;

  _selectFacilityState();

  @override
  void initState() {
    super.initState();
    futureFacilities = fetchFacilities();
  }

  Future<List<Facility>> fetchFacilities({String? type}) async {
  final response = await http.get(Uri.parse('https://hookworm-solid-tahr.ngrok-free.app/facilities'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Facility> facilities = data.map((item) => Facility.fromJson(item)).toList();

    // Filter facilities based on type
    if (type != null) {
      return facilities.where((facility) => facility.type == type).toList();
    } else {
      return facilities;
    }
  } else {
    throw Exception('Failed to load facilities');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height:10),
            Row(
              children: [
                Image.asset('assets/filter.png',height:50,width:50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      futureFacilities = fetchFacilities(type: 'BBQ Pit');
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '  BBQ  ',
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      futureFacilities = fetchFacilities(type: 'Campsite');
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '  Campsites  ',
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      futureFacilities = fetchFacilities(type: 'Venues');
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '  Venues  ',
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Facilities',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Facility>>(
              future: futureFacilities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                 return Column(
                    children: snapshot.data!.map((facility) {
                      return Container(
                        
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black), // Add border
                          borderRadius: BorderRadius.circular(12), // Add border radius
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5), // Add margin for spacing
                        child: ListTile(
                          title: Text(facility.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          subtitle: Row(
                            children: [
                              Text('${facility.park}',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),                        
                                ),
                              Spacer(),
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Text('${facility.avgRating}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                   Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                 ],
                               ),
                            ],
                          ),
                          onTap: () {
                            // Handle facility tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavigationBarExampleApp(),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
