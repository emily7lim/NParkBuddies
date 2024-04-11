import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:npark_buddy/confirm_booking.dart';
import 'package:table_calendar/table_calendar.dart';
import 'view_facility.dart';
import 'package:auto_size_text/auto_size_text.dart';

//main for debugging
// void main() => runApp(const MaterialApp(
//   home: ConfirmBooking(),
// ));
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
            const Text('Pick a date'),
            Container(
              color: Colors.white,
              width: 300,
              height: 400,
              child: TableCalendar(
                focusedDay: today,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2040, 1, 1),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                onDaySelected: _onDaySelected,
              ),
            ),
            const Text('Available time slots'),
            Wrap(
              children: [
                for (int i = 0; i < 6; i++) ...{
                  OutlinedButton(
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
                                  time: 'time',
                                )),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFCF9F9E8),
                        minimumSize: const Size(100, 50),
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: const Text(
                      '11',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
