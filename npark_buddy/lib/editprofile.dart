import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

void main() => runApp(const MaterialApp(
  home: EditProfile(),
));

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {

  String username = Provider.of<UserData>(context, listen:false).username;
  String email = Provider.of<UserData>(context, listen:false).email;
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
                decoration: InputDecoration(
                  hintText: username,
                  border: const OutlineInputBorder(),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
              child: TextField(
                decoration: InputDecoration(
                  hintText: email,
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
                  onPressed: (){},
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
        
          ],
        ),
      ),
  
      );
  }
}