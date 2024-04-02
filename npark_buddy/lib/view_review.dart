// ignore_for_file: unused_import, prefer_const_constructors, use_super_parameters, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:npark_buddy/btmNavBar.dart';

class ViewReviews extends StatelessWidget {
  final String reviewText;

  const ViewReviews({Key? key, required this.reviewText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFCF9F9E8),
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationBarExampleApp()),
          );
        },
      ),
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20,),

                Center(
                  child: Text(
                    'Reviews',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),

                 //Venue, Activity, Date and Time
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    width: double.infinity, // Make the SizedBox width to match parent width
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), // Border color
                        borderRadius: BorderRadius.circular(12), // Border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BBQ pits',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'East Coast Park',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Date: 1 January 2024',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Time: 4:30PM',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  reviewText,
                  style: TextStyle(fontSize: 20),
                ),



              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => BottomNavigationBarExampleApp(),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.arrow_back),
      // ),
    );
  }
}
