import 'package:flutter/material.dart';
import 'btmNavBar.dart';

//main for debugging
void main() => runApp(const MaterialApp(
      home: Bookings(
        location: '',
      ),
    ));

class Bookings extends StatelessWidget {
  final String location;

  const Bookings({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
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
            ),
          ],
        ),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                'Selected park is',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                height: 200,
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomNavigationBarExampleApp()),
                    );
                  },
                  style: TextButton.styleFrom(
                      minimumSize: const Size(280, 0),
                      backgroundColor: Color(0xFFFEFBEA),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(style: BorderStyle.solid))),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Image(
      //   image: AssetImage(),
      // ),
    );
  }
}
