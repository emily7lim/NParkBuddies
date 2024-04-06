// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:npark_buddy/btmNavBar.dart';
import 'package:npark_buddy/view_review.dart';


class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  final _reviewController = TextEditingController();

  void Review() {
    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewReviews(reviewText: _reviewController.text.trim(),)), 
    );
    showDialog(context: context, builder: (context){
      return Center(
        child: AlertDialog(
          content:Text('             Review uploaded', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ),
      );
    });

  }

  @override
  void dispose(){
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










                RatingBar.builder(
                  minRating: 1,
                  itemSize: 60,
                  itemBuilder: (context, _) => Icon(Icons.star,color: Colors.amber,), 
                  onRatingUpdate: (rating){}),
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
                onTap: Review,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(12),
                    ),
                  child: const Center(
                    
                    child: Text(
                      'Review',
                      style: TextStyle(color: Colors.white,
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