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
                image: AssetImage('assets/pic3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: UserProfileCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: UserProfile(),
      ),
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
          backgroundImage: AssetImage('assets/bg3.jpg'),
        ),
        SizedBox(height: 20.0),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Email: john.doe@example.com',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Contact: +1234567890',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'House Name: ABC House',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Area: XYZ Area',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'District: PQR District',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'City : Sample City',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            // Add your submission logic here
            // This function will be called when the button is pressed
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
          ),
          child: Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Hobbio',
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
