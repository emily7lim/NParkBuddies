// ignore_for_file: unused_import, prefer_const_constructors, use_super_parameters, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:npark_buddy/btmNavBar.dart';

double calculateAverageRating(List<double> ratings) {
  if (ratings.isEmpty) return 0.0;
  double totalRating = ratings.reduce((value, element) => value + element);
  double averageRating = totalRating / ratings.length;
  return double.parse(averageRating.toStringAsFixed(1));
}

class ViewReviews extends StatelessWidget {
  final String reviewText;
  final double rating;
  final List<double> ratingsList;
  final List<String> allReviews;

  const ViewReviews({Key? key, required this.reviewText, required this.rating, required this.ratingsList, required this.allReviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double averageRating = calculateAverageRating(ratingsList);
    
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
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 30,),

                Center(
                  child: Text(
                    'Reviews',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),

                 //Venue, Activity, Date and Time
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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

                              //Activity
                              Text(
                                '      BBQ pits',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),

                              //location
                              Text(
                                'East Coast Park',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              
                              //date
                              Text(
                                'Date: 1 January 2024',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),

                              //time
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

                //Average reviews displayed 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1), // Display numerical value
                      style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5), // Add spacing between stars and numerical value
                    RatingBarIndicator(
                      rating: averageRating, // Display stars
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 50.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),


                //past reviews
                Expanded(
                  child: ListView.builder(
                    itemCount: allReviews.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 20), // Add spacing between each review
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${ratingsList[index]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        RatingBarIndicator(
                                          rating: ratingsList[index],
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20.0,
                                          direction: Axis.horizontal,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      allReviews[index],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      '5 March 2024',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      );
  }
}
