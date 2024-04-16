import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Hobbio/forgot_password.dart';
import 'package:Hobbio/user_editprofile.dart';

class MyProfile extends StatelessWidget {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My Profile',
                    style: TextStyle(
                       fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Hobbio3',
                    color: Color.fromRGBO(0, 1, 0, 1),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  MyProfileCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: MyProfileContent(),
      ),
    );
  }
}

class MyProfileContent extends StatefulWidget {
  @override
  _MyProfileContentState createState() => _MyProfileContentState();
}

class _MyProfileContentState extends State<MyProfileContent> {
  String name = 'Loading...';
  String email = 'Loading...';
  String contact = 'Loading...';
  String housename = 'Loading...';
  String area = 'Loading...';
  String image = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_user')
              .where('user_id', isEqualTo: userId)
              .limit(1)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          name = doc['user_name'] ?? 'Error Loading Data';
          email = doc['user_email'] ?? 'Error Loading Data';
          contact = doc['user_contact'] ?? 'Error Loading Data';
          housename = doc['user_housename'] ?? 'Error Loading Data';
          area = doc['user_area'] ?? 'Error Loading Data';
          image = doc['user_photo'];
        });
      } else {
        setState(() {
          name = 'Error Loading Data';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage: image.isNotEmpty
              ? NetworkImage(image)
              : AssetImage('assets/pro.jpg') as ImageProvider,
        ),
        SizedBox(height: 20.0),
        Text(
          name,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Email: $email',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
          softWrap: false,
        ),
        SizedBox(height: 10.0),
        Text(
          'Contact: $contact',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'House Name: $housename',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Area: $area',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Hobbio8',
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserEditProfile()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 65, 89, 124),
            ),
          ),
          child: Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Hobbio',
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPassword(title: 'Change Password',)),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 65, 89, 124),
            ),
          ),
          child: Text(
            'Change Password',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Hobbio',
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
