import 'package:flutter/material.dart';
import 'package:hobbio/view_packages.dart';
import 'package:hobbio/book_package.dart';

class ViewPackages extends StatelessWidget {
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
                  'Kungfu Masters', // Replace with your center name here
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
              packageName: 'Kungfu Pack 1',
              packageCost: '6000',
              packageDuration: '6 Months',
              packageDescription: 'Beginner',
            ),
            SizedBox(height: 16.0),
            CenterCard(
              packageName: 'Kungfu Pack 2',
              packageCost: '10000',
              packageDuration: '10 Months',
              packageDescription: 'Intermediate',
            ),
          ],
        ),
      ),
    );
  }
}

class CenterCard extends StatelessWidget {
  final String packageName;
  final String packageCost;
  final String packageDuration;
  final String packageDescription;

  CenterCard({
    required this.packageName,
    required this.packageCost,
    required this.packageDuration,
    required this.packageDescription,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              packageName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Cost: $packageCost | Duration: $packageDuration',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              packageDescription,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Book Package Logic
                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookPackage()),
          );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 14, 45, 70)), // Change button color here
              ),
              child: Text(
                'Book Package',
                style: TextStyle(color: Colors.white), // Change text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
