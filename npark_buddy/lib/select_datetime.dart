import 'package:flutter/material.dart';
import 'package:npark_buddy/confirm_booking.dart';
import 'view_facility.dart';

//main for debugging
// void main() => runApp(const MaterialApp(
//   home: ConfirmBooking(),
// ));

class SelectDateTime extends StatelessWidget {
  final String location;

  const SelectDateTime({super.key, required this.location});
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
                width: 350,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: const Color(0xFCF9F9E8),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('BBQ Pits',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(location,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900)),
                    ),
                  ],
                )),
            Text('Available time slots'),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmBooking(
                            location: location,
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
