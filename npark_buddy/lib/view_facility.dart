import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npark_buddy/select_datetime.dart';
import 'btmNavBar.dart';
import 'select_datetime.dart';

//main for debugging
void main() => runApp(const MaterialApp(
      home: ViewFacility(
        location: '',
      ),
    ));

class ViewFacility extends StatelessWidget {
  final String location;

  const ViewFacility({super.key, required this.location});

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

      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Selected park is',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            location,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Facilities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: 400,
              child: ListView(
                children: [
                  for (int i = 0; i < 8; i++) ...{
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectDateTime(location: location)),
                        );
                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: Text("Item List - $i")),
                    )
                  },
                ],
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
                        const BottomNavigationBarExampleApp()),
                  );
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFCF9F9E8),
                    minimumSize: const Size(300, 50),
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
        ],
      ),
      // Image(
      //   image: AssetImage(),
      // ),
    );
  }
}
