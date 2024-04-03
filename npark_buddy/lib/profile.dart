import 'package:flutter/material.dart';

//main for debugging
void main() => runApp(const MaterialApp(
  home: Profile(),
));

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      //         child: Image.asset(
      //           'assets/logo.png',
      //           height: 70,
      //           width: 70,
      //         ),
      //       ),
      //       const Text(
      //         'ParkBuddy',
      //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      //       )
      //   ],
      // ),

      //   backgroundColor: const Color(0xFF2B512F),
      //   foregroundColor: Colors.white,
      //   toolbarHeight: 110,
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Center(
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        
            Container(
              width: 390,
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFF2B512F),
              ),
              child: Column(
                children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/profilepic.png'),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
        
                    const Padding(
                      padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                      child: Text(
                        'johndoe123@gmail.com',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ]
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  child: const Text(
                    'Change password',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.black,
                    ),
                  )
                  
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(0,120,0,0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      titlePadding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
                      backgroundColor: const Color(0xFFFEFBEA),
                      surfaceTintColor: const Color(0xFFFEFBEA),
                      title: const Center(child: Text('Are you sure you want to log out?')),
                      titleTextStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        
                      ),
                      actions: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  backgroundColor: const Color(0xFFFEFBEA),
                                  side: const BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                              
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context, 'Logout'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  backgroundColor: Colors.red[900],
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                              
                                  )
                                ),
                              ),
                            ),
                          ],
                        )
                        
                      ]
                    )
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )


    );
  }
}

