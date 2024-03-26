import 'package:flutter/material.dart';
import 'register.dart';
import 'btmNavBar.dart';
import 'resetPW.dart';
import 'allStyle.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

      body: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          const Center(
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(70, 50, 70, 10),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: TextFieldStyle.unclickedTF,
                focusedBorder: TextFieldStyle.clickedTF,
                hintText: 'Username or email',
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
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      color: Color(0xFF023307), fontWeight: FontWeight.w500),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResetPW()),
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
              );
            },
            style: TextButton.styleFrom(
                minimumSize: const Size(280, 0),
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(80, 200, 0, 20),
                  child: Text(
                    'Don\'t have an Account? ',
                    style: TextStyle(fontSize: 14),
                  )),
              GestureDetector(
                child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 200, 0, 20),
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5F7B5D)),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
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
