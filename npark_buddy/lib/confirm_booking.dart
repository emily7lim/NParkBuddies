import 'package:flutter/material.dart';
import 'package:npark_buddy/btmNavBar.dart';
import 'select_datetime.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'provider.dart';
//main for debugging
// void main() => runApp(const MaterialApp(
//   home: ConfirmBooking(),
// ));

//by gpt 
String mergeDateTime (selected_date, selected_time){

  // Parse the date string
  try{
  DateTime date = DateFormat("dd MMMM yyyy").parse(selected_date);
  print(date);

  // Parse the time string
  DateTime time = DateFormat('h:mm').parse(selected_time);
  print(time);

  // Combine the date and time into a new DateTime object
  DateTime combinedDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  print (combinedDateTime);

  // Format the combined DateTime object to the desired format
  String formattedDateTime = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(combinedDateTime.toUtc());
  print(formattedDateTime);
  return(formattedDateTime);
  // return('hello');
  } catch (e){
    print('caught');
    return('ERROR PARSING');
  }
}

Future<void> confirmBooking(BuildContext context, String username, String park, String facility, String datetime) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/bookings'; //server

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
            title: const Text("Booking Confirmed"),
            content: const Text("Your booking has been made successfully."),
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
            title: const Text("Booking Failed"),
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
    print("ERROR BOOKING");
  }
}

class ConfirmBooking extends StatelessWidget {
  final String location;
  final String facility;
  final String time; //need to format back into datetime
  final String dates;
  var datetime = '';
  ConfirmBooking({super.key, required this.location, required this.facility, required this.dates, required this.time});
  @override
  Widget build(BuildContext context) {

  String username = Provider.of<UserData>(context, listen:false).username;

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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0,100,0,50),
              child: Center(
                child: Text(
                  'Confirm Booking',
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
                    child: Container(
                      height: 60,
                      child: AutoSizeText(
                        facility,
                          textAlign: TextAlign.center,
                        style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900
                      )
                      ),
                    ),
                  ),
                    Container(
                      height: 50,
                      child: AutoSizeText(
                        location,
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
                          'Date:\t\t\t\t' + dates,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900                  
                        )
                      ),
                      Text(
                        'Time:\t\t\t\t' + time,
                        style: const TextStyle(
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

                    datetime = mergeDateTime(dates, time);
                    // datetime = mergeDateTime();
                    // print(datetime);

                    print(username);
                    print(location);
                    print(facility);
                    print(datetime);
                    confirmBooking(context, username, location, facility, datetime);

                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green[900],
                    side: const BorderSide(color: Color(0x008b0000)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w500, 
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectDateTime(location: location, facility: facility,)),
                    );
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