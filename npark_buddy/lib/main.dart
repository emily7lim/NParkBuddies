import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Landing(),
    ));

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Column(
        children: <Widget>[
          SizedBox(height: 180),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text(
                'ParkBuddy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
              child: Text(
                'Your one-stop app for parks in Singapore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              'Explore now',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(280,0),
                foregroundColor: Colors.green[900],
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )),
          ),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFCF9F9E8),
      appBar: AppBar(
        title: Text('ParkBuddy'),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 22,
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
