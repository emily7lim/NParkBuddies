import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npark_buddy/provider.dart';
import 'package:provider/provider.dart';
import 'cancel_booking.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

//main for debugging
void main() => runApp(const MaterialApp(
  home: Bookings(),
));

Future<Album> curAlbum(username) async {
  final response = await http.get(Uri.parse(
      'https://hookworm-solid-tahr.ngrok-free.app/profiles/' +
          username +
          '/bookings'));
//todo
  if (response.statusCode == 200) {
    // if(jsonDecode(response.body)['current_bookings']==null){
    //   return Album.fromJson(
    //       jsonDecode(response.body)['current_bookings'] as List<dynamic>);
    // }
    if (jsonDecode(response.body)['current_bookings'].length != 0) {print('u');
    return Album.fromJson(
        jsonDecode(response.body)['current_bookings'] as List<dynamic>);
    } else { //todo
      return Album.fromJson(
          jsonDecode(response.body)['current_bookings'] as List<dynamic>);
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load curBookings');
  }
}

//todo
Future<Album> pastAlbum(username) async {
  final response = await http.get(Uri.parse(
      'https://hookworm-solid-tahr.ngrok-free.app/profiles/' +
          username +
          '/bookings'));
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['past_bookings'].length != 0) {print('g');
    return Album.fromJson(
        jsonDecode(response.body)['past_bookings'] as List<dynamic>);
    } else {
      print('d');
      return Album.fromJson(
          jsonDecode(response.body)['past_bookings'] as List<dynamic>);
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pastBookings');
  }
}

class Album {
  final List<String> facility;
  final List<bool> cancel;
  final List<String> date;
  final List<String> time;
  final List<String> datetime;
  final List<String> park;

  const Album({
    required this.facility,
    required this.cancel,
    required this.date,
    required this.time,
    required this.datetime,
    required this.park,
  });

  factory Album.fromJson(List<dynamic> json) {
    List<String> facilityList = [];
    List<bool> cancelList = [];
    List<String> dateList = [];
    List<String> timeList = [];
    List<String> datetimeList = [];
    List<String> parkList = [];

    DateFormat inputFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');

    // Iterate over each JSON element in the list
    for (int i = 0; i < json.length; i++) {
      dynamic element = json[i];

      DateTime dateTime = inputFormat.parse(element['datetime']);
      String formattedTime = DateFormat('h:mm a').format(dateTime);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      String formattedDateTime =
      DateFormat('dd MMM yyyy h:mm a').format(dateTime);

      facilityList.add(element['facility']);
      cancelList.add(element['cancelled']);
      dateList.add(formattedDate);
      timeList.add(formattedTime);
      datetimeList.add(formattedDateTime);
      parkList.add(element['park']);
    }

    // Return an Album object with lists of extracted values
    return Album(
      facility: facilityList,
      cancel: cancelList,
      date: dateList,
      time: timeList,
      datetime: datetimeList,
      park: parkList,
    );
  }
}

class Bookings extends StatefulWidget {
  const Bookings({super.key});
  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  late Future<Album> curBook;
  late Future<Album> pastBook;

  @override
  void initState() {
    super.initState();
    curBook = curAlbum(Provider.of<UserData>(context, listen:false).username);
    pastBook = pastAlbum(Provider.of<UserData>(context, listen:false).username);
    // curBook = curAlbum('diontest');
    // pastBook = pastAlbum('diontest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFEFBEA),
        body: SingleChildScrollView(
            child: Column(
              
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text('Current Bookings',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      )),
                ),
                FutureBuilder<Album>(
                  future: curBook,
                  builder: (context, snapshot) {
                    print(snapshot);
                    if (snapshot.hasData) {
                      return Container(
                          height: 250,
                          width: 390,
                          child: ListView(children: [
                            for (int i = 0;
                            i < snapshot.data!.facility.length;
                            i++) ...{
                              Container(
                                  width: 390,
                                  height: 210,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xFF2B512F),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data!.date[i],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Text(snapshot.data!.time[i],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Text(snapshot.data!.park[i],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Text(snapshot.data!.facility[i],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 0, 0),
                                          child: OutlinedButton(
                                            onPressed: () {
                                              String facility = snapshot.data!.facility[i];
                                              String park = snapshot.data!.park[i];
                                              String username = Provider.of<UserData>(context, listen:false).username;
                                              String datetime = snapshot.data!.datetime[i];
                                              String date = snapshot.data!.date[i];
                                              String time = snapshot.data!.time[i];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CancelBooking(facility: facility, park: park, username: username, datetime: datetime, date:date, time:time),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 130, vertical: 6),
                                              backgroundColor: Colors.red[900],
                                              side: const BorderSide(
                                                  color: Colors.red),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(15)),
                                            ),
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 10),
                            }
                          ]));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
                    child: Center(
                      child: Text('Past Bookings',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          )),
                    )),
                FutureBuilder(
                  future: pastBook,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          height: 400,
                          width: 390,
                          child: ListView(children: [

                            for (int i = 0;
                            i < snapshot.data!.facility.length;
                            i++) ...{
                              if(snapshot.data!.cancel[i]==false)...[//todo
                                const Text('todo Checked', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,),),
                                const Divider()
                              ]else...[
                                const Text('todo Not Checked', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,),),
                                const Divider()
                              ],
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
                                                    snapshot.data!.datetime[i],
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    snapshot.data!.park[i],
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
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/rate_arrow.png'),
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
                          ]));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                )
              ],
            )));
  }
}
