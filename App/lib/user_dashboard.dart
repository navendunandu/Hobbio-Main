import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hobbio/login_screen.dart';
import 'package:hobbio/search_centers.dart';
import 'package:hobbio/user_profile.dart';
import 'package:hobbio/user_complaints.dart';
import 'package:hobbio/user_feedbacks.dart';
import 'package:hobbio/search_centers.dart';
import 'package:hobbio/favorites.dart';
import 'package:hobbio/bookings.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        // Use Stack to place widgets on top of each other
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/bg.png'), // Replace 'assets/bg2.jpg' with your image path
              fit: BoxFit.fill,
              alignment: Alignment.centerRight, // Adjust the alignment here
            ),
          ),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, top: 80),
                child: Text(
                  'Sheen', // Replace with the actual user name
                  style: TextStyle(
                    fontFamily: 'hobbio',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 8, 15), // You can change the color according to your design
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),

              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Color.fromARGB(212, 45, 128, 205), // Border color
                          width: 10, // Border thickness
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 22),
                           // Adjust the padding as needed
                      child: Text(
                        "Home",
                        style: TextStyle(
                          fontFamily:
                              'Hobbio3', // Check if this font exists in your project
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 10), // Adjust the padding as needed
                      child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => MyProfile(),
                          ),
                        );
                      },
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontFamily:
                                'Hobbio3', // Check if this font exists in your project
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 10), // Adjust the padding as needed
                      child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => SearchPage(),
                          ),
                        );
                      },

                        child: Text(
                          "Search Centers",
                          style: TextStyle(
                            fontFamily:
                                'Hobbio3', // Check if this font exists in your project
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
             Row(
  children: [
    Container(
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 10), 
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewBookingPage(),
              ),
            );
          },
          child: Text(
            "View Bookings",
            style: TextStyle(
              fontFamily: 'Hobbio3', // Check if this font exists in your project
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
          ),
        ),
      ),
    ),
  ],
),

              Row(
  children: [
    Container(
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 10), // Adjust the padding as needed
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage()),
            );
          },
          child: Text(
            "Favorites",
            style: TextStyle(
              fontFamily: 'Hobbio3', // Check if this font exists in your project
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
          ),
        ),
      ),
    ),
  ],
),

              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 10), // Adjust the padding as needed
                      child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => UserComplaints(),
                          ),
                        );
                      },
                        child: Text(
                          "Complaints",
                          style: TextStyle(
                            fontFamily:
                                'Hobbio3', // Check if this font exists in your project
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 10), // Adjust the padding as needed
                      child: GestureDetector(
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => UserFeedbacks(),
                          ),
                        );
                      },

                        child: Text(
                          "Feedbacks",
                          style: TextStyle(
                            fontFamily:
                                'Hobbio3', // Check if this font exists in your project
                            fontWeight: FontWeight.w500,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Row(
              //   children: [
              //     Container(
              //       child: Padding(
              //         padding: EdgeInsets.only(
              //             left: 50, top: 10), // Adjust the padding as needed
              //         child: Text(
              //           "Profile",
              //           style: TextStyle(
              //             fontFamily:
              //                 'Hobbio3', // Check if this font exists in your project
              //             fontWeight: FontWeight.w500,
              //             fontSize: 23,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              //  Row(
              //           children: [
              //             Container(
              //               child: Padding(
              //         padding: EdgeInsets.only(
              //             left: 50, top: 10), // Adjust the padding as needed
              //         child:
              //              Icon(
              //           Icons.power_settings_new_rounded,
              //           size: 32, // Increase the size of the icon
              //           color: Colors.black, // You can change the color of the icon
              //         ),

              //             ),
                          
                         

              //           ],

              //         ),

                     Row(
  children: [
    Container(
      child: Padding(
        padding: EdgeInsets.only(left: 25,top: 200), // Adjust the padding as needed
        child: Row( // Wrap Icon and Text in a Row
          children: [
            Icon(
              Icons.power_settings_new_rounded,
              size: 30, // Adjust the size as needed
              color: Colors.black, // Adjust the color as needed
            ),
             // Add space between Icon and Text
            Text(
              "Logout",
              style: TextStyle(
                fontFamily: 'Hobbio3', // Check if this font exists in your project
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),







              
             
              

             

              

             
             
            ],
                     
          ),
        ),
      );
    }
  }
}
