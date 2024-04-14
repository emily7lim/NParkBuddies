import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npark_buddy/confirm_booking.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'view_facility.dart';
import 'package:auto_size_text/auto_size_text.dart';

// main for debugging
void main() => runApp(const MaterialApp(
  home: SelectDateTime(
    location: '',
    facility: '',
  ),
));

extension DateTimeFormat on DateTime {
  String fullDate() {
    return DateFormat.yMMMMd('en_US').format(
        DateTime.fromMicrosecondsSinceEpoch((this).microsecondsSinceEpoch));
  }
}

timeSlots(DateTime today, BuildContext context, location, facility, timing) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
    child: TextButton(
      onPressed: () {
        String dates = today.fullDate().toString().replaceAll(",", "");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmBooking(
                location: location,
                facility: facility,
                dates: dates.split(" ")[1] +
                    " " +
                    dates.split(" ")[0] +
                    " " +
                    dates.split(" ")[2],
                time: timing,
              )),
        );
      },
      style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFE4E4E4),
          minimumSize: const Size(105, 55),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Text(
        timing,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ),
  );
}

Future<Album> fetchAlbum(park, facility, date) async {
  final response = await http.get(Uri.parse(
      'https://hookworm-solid-tahr.ngrok-free.app/timeslots/$park/$facility/$date'));
  print(jsonDecode(response.body)['available_timeslots']);
  print('f');
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final List<String> date;
  final List<String> time;

  const Album({
    required this.date,
    required this.time,
  });

  factory Album.fromJson(Map<String, dynamic> json) {

    List<String> timeList = [];
    List<String> dateList = [];
    DateFormat inputFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');

    for (int i = 0; i < json['available_timeslots'].length; i++) {
      dynamic element = json['available_timeslots'][i];

      DateTime dateTime = inputFormat.parse(element);
      String formattedTime = DateFormat('h:mm a').format(dateTime);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

      dateList.add(formattedDate);
      timeList.add(formattedTime);
      print(formattedTime);
      print('hhhhh');
      print(formattedDate);
      // facilityList.add(element['facility']);
    }
    return Album(
      date: dateList,
      time: timeList,
    );
  }
}

class SelectDateTime extends StatefulWidget {
  final String location;
  final String facility;

  const SelectDateTime(
      {super.key, required this.location, required this.facility});

  @override
  State<SelectDateTime> createState() =>
      _SelectDateTimeState(location: location, facility: facility);
}

class _SelectDateTimeState extends State<SelectDateTime> {
  final String location;
  String facility;
  DateTime today = DateTime.now();

  late Future<Album> futureAlbum;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print(today);
      print('yy');
    });
  }

  @override
  _SelectDateTimeState({required this.location, required this.facility});

  @override
  void initState() {
    super.initState();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(today);
    futureAlbum = fetchAlbum(location, facility, formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFCF9F9E8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 70,
                  width: 70,
                ),
              ),
              const Text(
                'ParkBuddy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              )
            ],
          ),
          backgroundColor: const Color(0xFF2B512F),
          foregroundColor: Colors.white,
          toolbarHeight: 110,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
                width: 380,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: const Color(0xFCF9F9E8),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        height: 32,
                        width: 366,
                        child: AutoSizeText(
                          facility,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Container(
                        height: 30,
                        child: AutoSizeText(location,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pick a date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              color: Colors.white,
              width: 300,
              height: 400,
              child: TableCalendar(
                focusedDay: today,
                calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: Color(0xFF2B512F), shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: Color(0xFF7DAF7E), shape: BoxShape.circle)),
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2040, 1, 1),
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                onDaySelected: _onDaySelected,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Available time slots',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {

                // Parse the input date string into a DateTime object
                DateTime dateTime = DateTime.parse(today.toString());

                // Define the desired date format
                DateFormat outputDateFormat = DateFormat('dd MMM yyyy');

                // Format the DateTime object to the desired format
                String formatedDate = outputDateFormat.format(dateTime);

                // print(formattedDate);
                print(today);
                if (snapshot.hasData) {

                  return Container(
                      height: 250,
                      width: 350,
                      child: Wrap(children: [
                        for (int i = 0;
                        i < snapshot.data!.time.length;
                        i++) ...{

                          // if(snapshot.data!.date[i] == formatedDate)...{
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                              child: TextButton(
                                onPressed: () {
                                  String dates = today
                                      .fullDate()
                                      .toString()
                                      .replaceAll(",", "");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConfirmBooking(
                                          location: location,
                                          facility: facility,
                                          dates: dates.split(" ")[1] +
                                              " " +
                                              dates.split(" ")[0] +
                                              " " +
                                              dates.split(" ")[2],
                                          time: snapshot.data!.time[i],
                                        )),
                                  );
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFE4E4E4),
                                    minimumSize: const Size(105, 55),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10))),
                                child: Text(
                                  snapshot.data!.time[i],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          // }

                        } //forloop
                      ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            // Wrap(
            //   children: [
            //     for (int i = 0; i < 20; i++) ...{
            //       if (i == 12) ...[
            //         timeSlots(today, context, location, facility, '$i:00 PM')
            //       ] else if (i < 12) ...[
            //         timeSlots(today, context, location, facility, '$i:00 AM')
            //       ] else ...[
            //         timeSlots(
            //             today, context, location, facility, '${i - 12}:00 PM')
            //       ]
            //     },
            //   ],
            // ),
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
                              ViewFacility(location: location)),
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
          ]),
        ));
  }
}
