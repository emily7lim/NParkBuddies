import 'package:flutter/material.dart';
import 'btmNavBar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

//main for debugging
// void main() => runApp(const MaterialApp(
//   home: CancelBooking(),
// ));

//HTTP POST to cancel booking, JUST NEED CHECK WHETHER FORMAT OF THE DATE TIME IS OK
Future<void> cancelBooking(BuildContext context, String username, String park, String facility, String datetime) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/bookings/cancel'; //server

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'park': park,
        'facility': facility,
        'datetime': datetime,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then go back to home page
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Booking Cancelled"),
            content: const Text("Your booking has been cancelled successfully."),
            backgroundColor: const Color(0xFCF9F9E8),
            surfaceTintColor: Colors.white,
            actions: <Widget>[
              TextButton(
                child: const Text("Close", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                  );
                },
              ),
            ],
          );
        },
      );

      
    } else {
      //cancellation failed from posting
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cancellation Failed"),
            content: const Text("An error has occurred."),
            backgroundColor: const Color(0xFCF9F9E8),
            surfaceTintColor: Colors.white,
            actions: <Widget>[
              TextButton(
                child: const Text("Close", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print("ERROR CANCELLATION");
  }
}


class CancelBooking extends StatefulWidget {
  final String facility;
  final String park;
  final String username;
  final String datetime;
  final String date;
  final String time;
  CancelBooking({super.key, required this.facility, required this.park, required this. username, required this.datetime, required this.date, required this.time});
  @override
  State<CancelBooking> createState() => _CancelBookingState(facility: facility, park: park, username: username, datetime: datetime, date: date, time:time);
}

class _CancelBookingState extends State<CancelBooking> {
  final String facility;
  final String park;
  final String username;
  final String datetime;
  final String date;
  final String time;

  @override
  _CancelBookingState({required this.facility, required this.park, required this.username, required this.datetime, required this.date, required this.time});

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

        backgroundColor: const Color(0xFF2B512F),
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0,100,0,50),
              child: Center(
                child: Text(
                  'Cancel Booking?',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900                  
                  )
                ),
              ),
            ),
        
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: const Color(0xFCF9F9E8),
                border: Border.all(color: Colors.black),
              ),
        
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      facility,
                      style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900                  
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Text(
                      park,
                      style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900                  
                    )
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date:\t\t\t' + date,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900                  
                        )
                      ),
                      Text(
                        'Time:\t\t\t' + time,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900                  
                        )
                      )
                    ],
                  ),
                  
                ],
              )
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(0,120,0,0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: (){
                    
                    // cancelBooking(context, username, park, facility, datetime);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    side: const BorderSide(color: Color(0x008b0000)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFCF9F9E8),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                      
                    )
                  ),
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
          ]
        ),
      )


    );
  }
}