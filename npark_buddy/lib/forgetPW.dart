import 'package:flutter/material.dart';
import 'package:npark_buddy/login.dart';
import 'allStyle.dart';
import 'checker.dart';

import 'package:provider/provider.dart';
import 'provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> forgetPW(BuildContext context, username, String password) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/profiles/<string:user_identifier>/change_password'; //server

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_identifier': username,
        'new_password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then go back to home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      
    } else {
      //show some dialog, also need some controller to format the input
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("http Failed"),
            content: Text('$response.statusCode'),
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
    print("ERROR FORGET PASSWORD");
  }
}

class ForgetPW extends StatelessWidget{
  ForgetPW({super.key});

  final pwControllerOne =TextEditingController();
  final pwControllerTwo =TextEditingController();
  final usernameController = TextEditingController();

  var passwordOne = '';
  var passwordTwo = '';
  var username = '';

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
        backgroundColor: const Color(0xFF2B512F),
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: Text(
                'Forget Password',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(0, 0, 85, 0),
            //   child: Text(
            //     'Enter new password',
            //     style: TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            // ),
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
              padding: const EdgeInsets.fromLTRB(70, 20, 70, 10),
              child: TextField(
                controller: pwControllerOne,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Enter New password',
                ),
                style: const TextStyle(height: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 70, 30),
              child: TextField(
                controller: pwControllerTwo,
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Confirm password',
                ),
                style: const TextStyle(height: 0.1),
              ),
            ),
            TextButton(
              onPressed: () {
                passwordOne = pwControllerOne.text;
                passwordTwo = pwControllerTwo.text;
                username = usernameController.text;
                
                if (passwordOne == '' || passwordTwo == '' || username == ''){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Password Reset Failed"),
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
                }

                else if (passwordOne == passwordTwo){ //passwords match
                  if (Checker.checkPassword(passwordOne)){ //check password format 
                    print('newpassword: $passwordOne');
                    forgetPW(context, username, passwordOne);
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Password Reset Failed"),
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
                  }
                }

                else{ 
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Password Reset Failed"),
                        content: const Text("Passwords do not match!"),
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
              },
              style: TextButton.styleFrom(
                  minimumSize: const Size(280, 0),
                  backgroundColor: Colors.green[900],
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
