import 'package:flutter/material.dart';
import 'package:npark_buddy/login.dart';
import 'allStyle.dart';

class Register extends StatelessWidget {
  const Register({super.key});

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
            const SizedBox(height: 100),
            const Center(
              child: Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 35,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create your new account',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 20, 70, 10),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Username',
                ),
                style: TextStyle(height: 0.1),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 10),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'E-mail',
                ),
                style: TextStyle(height: 0.1),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Password',
                ),
                style: TextStyle(height: 0.1),
              ),
            ),
            const Padding(
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
                  minimumSize: const Size(280, 0),
                  backgroundColor: Colors.green[900],
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ),
            Row(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(100, 150, 0, 20),
                    child: Text(
                      'Already have an Account? ',
                      style: TextStyle(fontSize: 14),
                    )),
                GestureDetector(
                  child: const Padding(
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
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ],
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
