import 'package:flutter/material.dart';
import 'package:npark_buddy/confirm_booking.dart';
import 'cancel_booking.dart';

//main for debugging
void main() => runApp(const MaterialApp(
  home: Bookings(),
));


class Bookings extends StatelessWidget {
  const Bookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Center(
              child: Text(
                'Current Booking',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                )
              ),
            )
          ),
          Container(
            width: 390,
            height: 280,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xFF2B512F),
              
            ),
            child:  Container(
              padding: EdgeInsets.fromLTRB(20,15,0,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  const Text(
                    '1 January 2025',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )
                  ),
                  const Text(
                    '6:00 PM',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )
                  ),
                  const Text(
                    'East Coast Park',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )
                  ),
                  const Text(
                    'Area D',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )
                  ),
              
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(15, 40, 0, 0),
                    child: OutlinedButton(
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              const CancelBooking(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding:  const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                        backgroundColor: Colors.red[900],
                        side:  const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                    
                        )
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Center(
              child: Text(
                'Past Bookings',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                )
              ),
            )
          ),
        ],
      )
    );
  }
}