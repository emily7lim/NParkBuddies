import 'package:flutter/material.dart';
import 'package:npark_buddy/login.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFCF9F9E8),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Container(
                child: Image.asset(
                  'assets/logo.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            Text(
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
          SizedBox(height: 100),
          Center(
            child: Text(
              'Register',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Create your new account',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70, 20, 70, 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
              style: TextStyle(height: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 70, 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E-mail',
              ),
              style: TextStyle(height: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
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
            padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
            child: Align(
              child: Text(
                'By signing up you agree to our Terms & Conditions and Privacy Policy',
                style: TextStyle(
                  fontSize: 11,
                ),
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
            style: TextButton.styleFrom(
                minimumSize: Size(280, 0),
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(100, 150, 0, 20),
                  child: Text(
                    'Already have an Account? ',
                    style: TextStyle(fontSize: 14),
                  )),
              GestureDetector(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 150, 0, 20),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFF38808),
                      ),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
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
