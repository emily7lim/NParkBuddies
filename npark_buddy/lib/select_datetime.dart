import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npark_buddy/confirm_booking.dart';
import 'package:table_calendar/table_calendar.dart';
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
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  _SelectDateTimeState({required this.location, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFCF9F9E8),
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
              )
            ],
          ),
          backgroundColor: Colors.green[900],
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
              child: Text('Pick a date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
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
              child: Text('Available time slots',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            ),
            Wrap(
              children: [
                for (int i = 8; i < 20; i++) ...{
                  //how to put TextButton into one fn or should I stful it
                  if (i == 12) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: TextButton(
                        onPressed: () {
                          String dates =
                              today.fullDate().toString().replaceAll(",", "");
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
                                      time: i.toString() + ':00 PM',
                                    )),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFE4E4E4),
                            minimumSize: const Size(105, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          i.toString() + ':00 PM',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ] else if (i < 12) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: TextButton(
                        onPressed: () {
                          String dates =
                              today.fullDate().toString().replaceAll(",", "");
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
                                      time: i.toString() + ':00 AM',
                                    )),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFE4E4E4),
                            minimumSize: const Size(105, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          i.toString() + ':00 AM',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: TextButton(
                        onPressed: () {
                          String dates =
                              today.fullDate().toString().replaceAll(",", "");
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
                                      time: (i - 12).toString() + ':00 PM',
                                    )),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFE4E4E4),
                            minimumSize: const Size(105, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          (i - 12).toString() + ':00 PM',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ]
                },
              ],
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
