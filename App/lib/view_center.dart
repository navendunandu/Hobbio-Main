import 'package:flutter/material.dart';

class ViewCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pic3.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  'Center Name', // Add your center name here
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Hobbio3',
                    color: Color.fromRGBO(0, 1, 0, 1),
                  ),
                ),
              ),
            ),
            CenterCard(
              courseName: 'Course 1',
              courseDescription: 'Description of Course 1',
            ),
            SizedBox(height: 16.0),
            CenterCard(
              courseName: 'Course 2',
              courseDescription: 'Description of Course 2',
            ),
            SizedBox(height: 16.0),
            CenterCard(
              courseName: 'Course 3',
              courseDescription: 'Description of Course 3',
            ),
          ],
        ),
      ),
    );
  }
}

class CenterCard extends StatelessWidget {
  final String courseName;
  final String courseDescription;

  CenterCard({
    required this.courseName,
    required this.courseDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              courseDescription,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // View Packages Logic
                  },
                  child: Text('View Packages'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // View Images Logic
                  },
                  child: Text('View Images'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
