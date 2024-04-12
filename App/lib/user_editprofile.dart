import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserEditProfile extends StatelessWidget {
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
              child: EditProfileCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: EditProfile(),
      ),
    );
  }
}

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap with SingleChildScrollView
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/bg3.jpg'),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            initialValue: 'Sheen', // Initial value
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 18.0, fontFamily: 'Hobbio8', fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: '8606147681', // Initial value
            decoration: InputDecoration(
              labelText: 'Contact',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 18.0, fontFamily: 'Hobbio8'),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: 'Karolil', // Initial value
            decoration: InputDecoration(
              labelText: 'House Name',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 18.0, fontFamily: 'Hobbio8'),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: 'Punnamattom', // Initial value
            decoration: InputDecoration(
              labelText: 'Area',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 18.0, fontFamily: 'Hobbio8'),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // Add your submission logic here
              // This function will be called when the button is pressed
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
            ),
            child: Center(
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Hobbio',
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

