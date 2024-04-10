import 'package:flutter/material.dart';
import 'package:npark_buddy/select_datetime.dart';

class Facilities extends StatefulWidget {
  final String location;
  const Facilities({Key? key, required this.location}) : super(key: key);

  @override
  State<Facilities> createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  late final String location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/filter.png', 
                        height: 40,
                        width: 40,
                      ),
                        
                       Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(12),
                                ),
                              child: const Center(
                                
                                child: Text(
                                  '  BBQ  ',
                                  style: TextStyle(color: Colors.white,
                                  fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                       Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(12),
                                ),
                              child: const Center(
                                
                                child: Text(
                                  '  Camps sites  ',
                                  style: TextStyle(color: Colors.white,
                                  fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(12),
                                ),
                              child: const Center(
                                
                                child: Text(
                                  '  Venues  ',
                                  style: TextStyle(color: Colors.white,
                                  fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                        
                  Text(
                    'Facilities near me',
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
                    ),
                  
                   Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectDateTime(
                                                    location: location)),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity, // Make the SizedBox width to match parent width
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black), // Border color
                          borderRadius: BorderRadius.circular(12), // Border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Activity
                                    Text(
                                      'BBQ pits',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                
                                    //location
                                    Text(
                                      'East Coast Park',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text('4.87',style: TextStyle(
                                  fontSize: 30,fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 40,
                              ),  
                            ],
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
      ),
    );
  }
}
