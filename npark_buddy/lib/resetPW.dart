import 'package:flutter/material.dart';
import 'package:npark_buddy/login.dart';
import 'allStyle.dart';

class ResetPW extends StatelessWidget {
  const ResetPW({super.key});

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
            const SizedBox(height: 190),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 70, 0),
              child: Text(
                'Create New Password',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 85, 0),
              child: Text(
                'Enter new password',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 20, 70, 10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Enter New password',
                ),
                style: TextStyle(height: 0.1),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, 30),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: TextFieldStyle.unclickedTF,
                  focusedBorder: TextFieldStyle.clickedTF,
                  hintText: 'Confirm password',
                ),
                style: TextStyle(height: 0.1),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
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
