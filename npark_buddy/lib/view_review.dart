import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  final String comment;
  final double rating;
  final String reviewer;

  Review({required this.comment, required this.rating, required this.reviewer});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewer: json['reviewer'],
      comment: json['comment'],
      rating: json['rating'].toDouble(), 
    );
  }
}

class ViewReviews extends StatelessWidget {
  final String parkName;
  final String facilityName;

  const ViewReviews({
    Key? key,
    required this.parkName,
    required this.facilityName, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2B512F),
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text('Reviews', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

            SizedBox(height: 10,),

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$facilityName',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$parkName',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Average Rating
            FutureBuilder<Map<String, dynamic>>(
                    future: fetchReviews(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final double avgRating = snapshot.data!['avgRating'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$avgRating',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                                
                              SizedBox(height: 5),
                              RatingBarIndicator(
                                rating: avgRating, 
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                itemCount: 5,
                                itemSize: 40.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),


            // Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity, 
                child: FutureBuilder<List<Review>>(
                  future: fetchReviews().then((reviewsMap) => reviewsMap['reviews']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return Column(
                        children: snapshot.data!.map((review) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                                          title: Text(
                                            '${review.reviewer}',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('${review.rating.toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),), // Fixed to 2 decimal places
                                                  SizedBox(width: 5), // Add some spacing between the rating and stars
                                                  RatingBarIndicator(
                                                    rating: review.rating, 
                                                    itemBuilder: (context, index) => Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 20.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5), // Add spacing between rating and comment
                                              Text(
                                                review.comment,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchReviews() async {
    final response = await http.get(Uri.parse(
        'https://hookworm-solid-tahr.ngrok-free.app/reviews/$parkName/$facilityName'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Review> reviews =
          data.map((item) => Review.fromJson(item)).toList();
      final double avgRating = getAverageRating(reviews);
      return {'reviews': reviews, 'avgRating': avgRating};
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  double getAverageRating(List<Review> reviews) {
    double sum = 0;
    for (var review in reviews) {
      sum += review.rating;
    }
    return reviews.isNotEmpty ? sum / reviews.length : 0;
  }
}
