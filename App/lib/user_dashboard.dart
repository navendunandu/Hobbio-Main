import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
                  'assets/bg2.jpg'), // Replace 'assets/bg2.jpg' with your image path
              fit: BoxFit.fill,
              alignment: Alignment.centerRight, // Adjust the alignment here
            ),
          ),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50, top: 70),
                child: Text(
                  'John Doe', // Replace with the actual user name
                  style: TextStyle(
                    fontFamily: 'hobbio2',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 6, 187,
                        175), // You can change the color according to your design
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
                          color: Colors.orange, // Border color
                          width: 10, // Border thickness
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 40), // Adjust the padding as needed
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
                          left: 50, top: 10), // Adjust the padding as needed
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
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 50, top: 10), // Adjust the padding as needed
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
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 50, top: 10), // Adjust the padding as needed
                      child: Text(
                        "View Bookings",
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
                          left: 50, top: 10), // Adjust the padding as needed
                      child: Text(
                        "Favorites",
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
                          left: 50, top: 10), // Adjust the padding as needed
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
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 50, top: 10), // Adjust the padding as needed
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
                ],
              ),

              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 50, top: 10), // Adjust the padding as needed
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
                ],
              ),

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
        padding: EdgeInsets.only(left: 45,top: 150), // Adjust the padding as needed
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
