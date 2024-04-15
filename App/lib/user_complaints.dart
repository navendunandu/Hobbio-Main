import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hobbio/view_complaints.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaints',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserComplaints(),
    );
  }
}

class UserComplaints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic3.jpg'), // Provide your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 550.0, // Adjust the height of the card as needed
                child: ComplaintsFormCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintsFormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ComplaintsForm(),
      ),
    );
  }
}

class ComplaintsForm extends StatefulWidget {
  @override
  _ComplaintsFormState createState() => _ComplaintsFormState();
}

class _ComplaintsFormState extends State<ComplaintsForm> {
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _complainttitleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final complaintContent = _complaintController.text.trim();
        final complainttitle = _complainttitleController.text.trim();
        try {
          // Add the complaint to Firestore
          await FirebaseFirestore.instance.collection('tbl_complaints').add({
            'user_id': userId,
            'complaint_title': complainttitle,
            'complaint_content': complaintContent,
            // Add a timestamp if needed
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Complaint submitted successfully.'),
            ),
          );
          _complaintController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting complaint: $e'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not logged in.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report your complaints here...',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Hobbio3',
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _complainttitleController,
            maxLines: null,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter your complaint title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Please enter a complaint title';
              }
              return null;
            },
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _complaintController,
            maxLines: null,
            minLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your complaint content',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Please enter a complaint content';
              }
              return null;
            },
          ),
          SizedBox(height: 20.0),
          Center(
            child: ElevatedButton(
              onPressed: _submitComplaint,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
                ),
                child: Text('Submit Complaint',
                 style: TextStyle(
              color: Colors.white,
              fontFamily: 'Hobbio',
              fontSize: 17,
            ),),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewComplaints()),
            );
          },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
                ),
                child: Text('View Complaints',
                 style: TextStyle(
              color: Colors.white,
              fontFamily: 'Hobbio',
              fontSize: 17,
            ),),
            ),
          ),
        ],
      ),
    );
  }
}


