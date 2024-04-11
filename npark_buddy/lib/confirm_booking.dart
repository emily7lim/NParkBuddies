import 'package:flutter/material.dart';
import 'select_datetime.dart';
import 'package:auto_size_text/auto_size_text.dart';

//main for debugging
// void main() => runApp(const MaterialApp(
//   home: ConfirmBooking(),
// ));

class ConfirmBooking extends StatelessWidget {
  final String location;
  final String facility;
  final String time;
  final String dates;
  const ConfirmBooking({super.key, required this.location, required this.facility, required this.dates, required this.time});
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      height: 60,
                      child: AutoSizeText(
                        facility,
                          textAlign: TextAlign.center,
                        style: TextStyle(
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900                  
                        )
                      ),
                      Text(
                        'Time:\t\t\t\t' + time,
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
                    // Navigator.push(
                      // context,
                      // MaterialPageRoute(builder: (context) => SelectDateTime(location: location)),
                    // );
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