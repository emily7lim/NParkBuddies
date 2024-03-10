import 'package:flutter/material.dart';

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
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
              child: Container(
                child: Image.asset(
                  'assets/logo.png',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            Text('ParkBuddy'),
          ],
        ),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
        toolbarHeight: 100,
      ),

      body: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Center(
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70,50,70,10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username or email',
              ),
              style: TextStyle(height: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70,0,70,20),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              style: TextStyle(height: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70,0,70,20),
            child: Align(
                alignment: Alignment.centerRight,
              child: Text(
                'Forgot Password ?'
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigator.push(
                // context,
                // MaterialPageRoute(builder: (context) => Home()),
              // );
            },
            child: Text(
              'Log In',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            style: TextButton.styleFrom(
                minimumSize: Size(280, 0),
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(100,200,70,20),
                  child: Text(
                      'Don\'t have an Account?',
                    style: TextStyle(fontSize: 15),
                  )
              ),
            ],
          ),
        ],
      ),
      // Image(
      //   image: AssetImage(),
      // ),
    );
  }
}
