import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic3.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: GlassCard(
                child: UserProfile(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;

  GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color.fromARGB(255, 246, 246, 246).withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 225, 222, 222).withOpacity(0.3),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/bg3.jpg'), // Replace with your profile picture
        ),
        SizedBox(height: 20.0),
        Text(
          'John Doe',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8',
          fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Text(
          'Email: john.doe@example.com',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
        SizedBox(height: 10.0),
        Text(
          'Contact: +1234567890',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
        SizedBox(height: 10.0),
        Text(
          'House Name: ABC House',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
        SizedBox(height: 10.0),
        Text(
          'Area: XYZ Area',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
        SizedBox(height: 10.0),
        Text(
          'District: PQR District',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
        SizedBox(height: 10.0),
        Text(
          'City : Sample City',
          style: TextStyle(fontSize: 18.0,
          fontFamily: 'Hobbio8'),
        ),
      ],
    );
    
  }
}