import 'package:flutter/material.dart';
import 'package:npark_buddy/login.dart';
import 'allStyle.dart';

import 'checker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> register(BuildContext context, String username, String email, String password) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/profiles/create'; //server

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then go back to home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      
    } else {
      //show some dialog, also need some controller to format the input
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: const Text("Account already exists. Please proceed to login."),
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
    print("ERROR REGISTER");
  }
}

int checkInput(context, username, email, password){

  if (username == '' || email == '' || password == ''){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: const Text("Empty Fields!"),
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
    return 0;
  }

  if (!Checker.checkPassword(password)){ //checkpassword returns false if problem
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: const Text("Password must be minimum 12 characters and contain at least 1 Uppercase and 1 Special Character!"),
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
    return 0;
  }

  if (!Checker.checkEmail(email)){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: const Text("Invalid Email Format!"),
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
    return 0;
  }


  return 1;
}

class Register extends StatelessWidget {
  Register({super.key});

  final usernameController =TextEditingController();
  final emailController = TextEditingController();
  final pwController =TextEditingController();

  var username = '';
  var email = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFCF9F9E8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
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
        backgroundColor: const Color(0xFF2B512F),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 20, 70, 10),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Username',
                ),
                style: const TextStyle(height: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 70, 10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'E-mail',
                ),
                style: const TextStyle(height: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
              child: TextField(
                controller: pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Password',
                ),
                style: const TextStyle(height: 0.1),
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
                username = usernameController.text;
                email = emailController.text;
                password = pwController.text;
                if (checkInput(context, username, email, password) == 1){
                  print('success');
                  register(context, username, email, password);
                }                
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
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const Login()),
                    // );
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
