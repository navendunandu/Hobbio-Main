import 'package:flutter/material.dart';

class ViewBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pic3.jpg'), // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.0),
                Text(
                  'Booking Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                     fontSize: 40.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Hobbio3',
                  ),
                ),
                SizedBox(height: 20.0),
                BookingDetailCard(
                  bookingDateTime: 'April 11, 2024, 1:57 PM', // Adjust date and time format
                  centerName: 'Artistic',
                  contact: '6537829102',
                  email: 'sinjumathews0005@gmail.com',
                  courseName: 'Kungfu Masters',
                  packageName: 'Kungfu Pack 2',
                  cost: '10000',
                  duration: '10 months',
                ),
                BookingDetailCard(
                  bookingDateTime: 'April 11, 2024, 12:51 AM', // Adjust date and time format
                  centerName: 'Artistic',
                  contact: '6537829102',
                  email: 'sinjumathews0005@gmail.com',
                  courseName: 'Kungfu Masters',
                  packageName: 'Kungfu Pack 2',
                  cost: '6000',
                  duration: '6 months',
                ),
                // Add more BookingDetailCard widgets as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingDetailCard extends StatelessWidget {
  final String bookingDateTime;
  final String centerName;
  final String contact;
  final String email;
  final String courseName;
  final String packageName;
  final String cost;
  final String duration;

  const BookingDetailCard({
    required this.bookingDateTime,
    required this.centerName,
    required this.contact,
    required this.email,
    required this.courseName,
    required this.packageName,
    required this.cost,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Date & Time: $bookingDateTime',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Center Name: $centerName',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Contact: $contact',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Course Name: $courseName',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Package Name: $packageName',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Cost: $cost',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Duration: $duration',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Cancel booking button logic
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 30, 54, 126), // Adjust button color as needed
                ),
              ),
              child: Text(
                'Cancel Booking',
                style: TextStyle(
                  color: Colors.white, // Adjust button text color as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
