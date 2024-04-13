// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'btmNavBar.dart';


class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  void _submitReview() async {
    final String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/reviews';

    // Create a map representing the review data
    final Map<String, dynamic> reviewData = {
      // 'username': 
      // 'park':
      // 'facility': 
      // 'datetime':
      'rating': _rating,
      'comment': _reviewController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reviewData),
      );
      //success
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Review Uploaded'),
              content: Text('Your review has been successfully uploaded.'),
              actions: [
                TextButton(
                  onPressed: (){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()));
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        //unsuccessful
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to upload review. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: (){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()));
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error submitting review: $e');
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Color(0xFCF9F9E8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'Rate and review',
                  style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(height: 15,),


                //Venue, Activity, Date and Time
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    width: double.infinity, 
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), 
                        borderRadius: BorderRadius.circular(12), 
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


              //Stars
               RatingBar.builder(
                  minRating: 0,
                  itemSize: 60,
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              const SizedBox(height: 10),
            
              //Review textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0,),
                child: TextField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 12.0),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Leave a review',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 60),
            
    
            
              //Review button
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: _submitReview, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),

             //Back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()), 
                );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                    ),
                  child: const Center(
                    
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.black,
                      fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          
            ],),
          ),
        ),
      )
    );
  }
}