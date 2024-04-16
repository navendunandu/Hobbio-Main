import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Hobbio/book_package.dart';

class ViewPackages extends StatefulWidget {
  final String id;
  final String title;

  const ViewPackages({Key? key, required this.id, required this.title}) : super(key: key);

  @override
  State<ViewPackages> createState() => _ViewPackagesState();
}

class _ViewPackagesState extends State<ViewPackages> {
  late Future<List<Map<String, dynamic>>> packageListFuture;

  @override
  void initState() {
    super.initState();
    packageListFuture = fetchPackages(widget.id);
  }

  Future<void> insertBooking(packageId,amount) async {
    try {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Check if the user document exists
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('tbl_user')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String uDoc = userSnapshot.docs.first.id;

        // Check if a booking with the same package ID already exists for this user
        QuerySnapshot<Map<String, dynamic>> existingBookingSnapshot = await FirebaseFirestore.instance
            .collection('tbl_booking')
            .where('user_id', isEqualTo: uDoc)
            .where('package_id', isEqualTo: packageId)
            .get();

        if (existingBookingSnapshot.docs.isNotEmpty) {
          Fluttertoast.showToast(
          msg: 'Already Booked',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
          print('A booking for this package already exists for the current user.');
        } else {
          // Insert into tbl_booking
          DocumentReference bookingRef = await FirebaseFirestore.instance.collection('tbl_booking').add({
            'booking_date_time': FieldValue.serverTimestamp(),
            'booking_status': 0,
            'package_id': packageId,
            'payment_amount': amount,
            'user_id': uDoc,
          });

          // Navigate to payment page with the inserted booking ID
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookPackage(id: bookingRef.id),
            ),
          );
        }
      } else {
        print("User document not found.");
      }
    } else {
      print("User ID not found.");
    }
  } catch (e) {
    print('Error inserting booking: $e');
  }
  }

  Future<List<Map<String, dynamic>>> fetchPackages(String courseId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
          .instance
          .collection('tbl_package')
          .where('course_id', isEqualTo: courseId)
          .get();

      List<Map<String, dynamic>> packages = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'packageName': doc['package_name'].toString(),
                'packageCost': doc['package_cost'].toString(),
                'packageDuration': doc['package_duration'].toString(),
                'packageDescription': doc['package_details'].toString(),
              })
          .toList();

      return packages;
    } catch (e) {
      print('Error fetching packages: $e');
      return [];
    }
  }

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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: packageListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> packages = snapshot.data ?? [];
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        widget.title, // Replace with your center name here
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hobbio3',
                          color: Color.fromRGBO(0, 1, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  ...packages.map((package) {
                    return CenterCard(
                      packageId: package['id'],
                      packageName: package['packageName'],
                      packageCost: package['packageCost'],
                      packageDuration: package['packageDuration'],
                      packageDescription: package['packageDescription'],
                      insertBooking: insertBooking,
                    );
                  }).toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class CenterCard extends StatelessWidget {
  final String packageId;
  final String packageName;
  final String packageCost;
  final String packageDuration;
  final String packageDescription;
  final Function(String, String) insertBooking;

  CenterCard({
    required this.packageName,
    required this.packageCost,
    required this.packageDuration,
    required this.packageDescription, required this.packageId, required this.insertBooking,
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
                insertBooking(packageId,packageCost);
                // Book Package Logic
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BookPackage(id: packageId, amount: packageCost,)),
                // );
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
