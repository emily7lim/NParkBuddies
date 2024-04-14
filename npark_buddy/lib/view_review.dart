import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  final String comment;
  final double rating;

  Review({required this.comment, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      comment: json['comment'],
      rating: json['rating'], 
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
      // backgroundColor: const Color(0xFCF9F9E8),
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title: Text('Reviews of $facilityName at $parkName'),
      //   backgroundColor: Colors.green[900],
      //   foregroundColor: Colors.white,
      //   toolbarHeight: 110,
      // ),
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

      

      body: Column(
        children: [
          SizedBox(height: 30,),
          Text('Reviews', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
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
                                '$facilityName',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$parkName',
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

          


          FutureBuilder<List<Review>>(
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
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final review = snapshot.data![index];
                    return ListTile(
                        title: Text(review.comment,
                        style: TextStyle(
                          fontWeight: 
                          FontWeight.bold,
                          fontSize: 20
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: review.rating, 
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
                      );

                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Review>> fetchReviews() async {
    final response = await http.get(Uri.parse(
        'https://hookworm-solid-tahr.ngrok-free.app/reviews/$parkName/$facilityName'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Review> reviews =
          data.map((item) => Review.fromJson(item)).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
