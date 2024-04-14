import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'btmNavBar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    Key? key,
    required this.facility,
    required this.park,
    required this.datetime,
    required this.date,
    required this.time, required String username,
  }) : super(key: key);

  final String facility;
  final String park;
  final String datetime;
  final String date;
  final String time;

  @override
  State<ReviewPage> createState() => _ReviewPageState();

  static String formatDateTime(String datetime) {
    // Define the format string for parsing the datetime
    String inputFormat = 'dd MMM yyyy h:mm a';

    // Parse the datetime string using the input format
    DateTime dateTime = DateFormat(inputFormat).parse(datetime, true);

    // Formatting DateTime to the desired format
    String formattedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(dateTime);

    return formattedDate;
  }
}

class _ReviewPageState extends State<ReviewPage> {
  late String _username;
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _username = Provider.of<UserData>(context, listen: false).username;
  }

  void _submitReview() async {
    final String apiUrl = 'https://hookworm-solid-tahr.ngrok-free.app/reviews';

    int rate = _rating.toInt();
    String date = ReviewPage.formatDateTime(widget.datetime);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': _username,
          'park': widget.park,
          'facility': widget.facility,
          'datetime': date,
          'rating': rate,
          'comment': _reviewController.text.trim(),
        }),
      );
      print (response.statusCode);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Review Uploaded'),
              content: Text('Your review has been successfully uploaded.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to upload review. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavigationBarExampleApp()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
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
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
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
                                widget.facility,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.park,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Date: ${widget.date}',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Time: ${widget.time}',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 12.0),
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Leave a review',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _submitReview,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
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
                      child: Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
