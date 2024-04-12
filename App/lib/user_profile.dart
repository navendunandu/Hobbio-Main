import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hobbio/user_editprofile.dart';

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
          'Sheen',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
  'Email: fathimasheen524@gmail.com',
  style: TextStyle(
    fontSize: 18.0,
    fontFamily: 'Hobbio8',
  ),
  softWrap: false,
),
        SizedBox(height: 10.0),
        Text(
          'Contact: 8606147681',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'House Name: Karolil',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Area: Punnamattom',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'District: Ernakulam',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'City : Muvattupuzha',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserEditProfile()),
    );
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
        SizedBox(height: 10.0),
        ElevatedButton(
         onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
    // View center details
  },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
          ),
          child: Center(
            child: Text(
              'Change Password',
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
