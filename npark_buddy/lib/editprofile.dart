import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'btmNavBar.dart';
import 'checker.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> changeUsername(BuildContext context, String old_username, String new_username) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/profiles/<string:username>/change_username'; //server

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'old_username': old_username,
        'new_username': new_username,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then go back to home page
      Provider.of<UserData>(context, listen:false).username = new_username;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarExampleApp()));
    } else {
      // username or email exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Profile Failed"),
            content: const Text("Username already exists"),
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
    print("ERROR EDITPROFILE");
  }

}

Future<void> changeEmail(BuildContext context, String old_email, String new_email) async {
  const String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/profiles/<string:username>/change_email'; //server

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'old_username': old_email,
        'new_username': new_email,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, store locally, then go back to home page
      Provider.of<UserData>(context, listen:false).email = new_email;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarExampleApp()));
    } else {
      // username or email exists
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Profile Failed"),
            content: const Text("Email already exists"),
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
    print("ERROR EDITPROFILE");
  }

}

// void main() => runApp(const MaterialApp(
//   home: EditProfile(),
// ));

void editProfile(BuildContext context, String old_username, String new_username, String old_email, String new_email){
  if (new_username == '' && new_email == ''){ //empty
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Profile Failed"),
            content: const Text("Empty Fields! Nothing to edit."),
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
    return;
  }
  
  if (new_username == ''){ //only editing email

    if (Checker.checkEmail(new_email)){ //store new email
      changeEmail(context, old_email, new_email); //pass to http  
    }

    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Profile Failed"),
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
    }
    return;
  }
  
  if (new_email == ''){ //only editing username

    changeUsername(context, old_username, new_username);
    return;
  }


  //if reach here, means changing both

    if (Checker.checkEmail(new_email)){ //store new email
      changeUsername(context, old_username, new_username);
      changeEmail(context, old_email, new_email);
        //pass to http
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Profile Failed"),
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
    }

}

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {

  String old_username = Provider.of<UserData>(context, listen:false).username;
  String old_email = Provider.of<UserData>(context, listen:false).email;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
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
            )
        ],
      ),

        backgroundColor: const Color(0xFF2B512F),
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body:  SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding:EdgeInsets.fromLTRB(0, 90, 0, 0),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  )
                )
              ),
            ),
            const Center(
              child: Text(
                'Edit your profile details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )
              )
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: old_username,
                  border: const OutlineInputBorder(),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: old_email,
                  border: const OutlineInputBorder(),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,15,0,0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: (){
                    editProfile(context, old_username, usernameController.text, old_email, emailController.text);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B512F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.white,
                    ),
                  )
                  
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,15,0,0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEFBEA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.black,
                    ),
                  )
                  
                ),
              ),
            ),
        
          ],
        ),
      ),
  
      );
  }
}