import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ViewBookingPage extends StatefulWidget {
  @override
  State<ViewBookingPage> createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  bool isLoading = true; // Add a boolean to track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> combinedDataList = [];

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading state to true before fetching data
    });
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Check if the user document exists
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('tbl_user')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String uDoc = userSnapshot.docs.first.id;
        QuerySnapshot<Map<String, dynamic>> bookingSnapshot =
            await FirebaseFirestore.instance
                .collection('tbl_booking')
                .where('user_id', isEqualTo: uDoc)
                .where('booking_status', isEqualTo: 1)
                .get();
        if (bookingSnapshot.docs.isNotEmpty) {
          // Use a list to store the results of fetchPackageData
          List<Map<String, dynamic>> packageAndCourseCenterDataList = [];
          for (var book in bookingSnapshot.docs) {
            Map<String, dynamic>? bookdata =
                book.data() as Map<String, dynamic>?;
            bookdata?['id'] = book.id;
            // Call fetchPackageData and await the result
            Map<String, dynamic>? packageAndCourseCenterData =
                await fetchPackageData(bookdata?['package_id']);
            if (packageAndCourseCenterData != null) {
              // Combine bookdata and packageAndCourseCenterData
              Map<String, dynamic> combinedData = {
                'bookdata': bookdata,
                'packageAndCourseCenterData': packageAndCourseCenterData,
              };
              // Add the combined data to the list
              packageAndCourseCenterDataList.add(combinedData);
            } else {
              print(
                  'Package data not found for package ID: ${bookdata?['package_id']}');
            }
          }
          // Set the list to state or do something else with it
          setState(() {
            // Set the list to the state variable
            // Make sure you have a state variable to hold this list
            // For example, List<Map<String, dynamic>> combinedDataList = [];
            combinedDataList = packageAndCourseCenterDataList;
            isLoading = false; // Set loading state to false after fetching data
          });
        } else {
          print('Booking data not found for user ID: $uDoc');
          setState(() {
            isLoading =
                false; // Set loading state to false if no booking data found
          });
        }
      } else {
        print('User not found');
        setState(() {
          isLoading = false; // Set loading state to false if user not found
        });
      }
    } else {
      print('User not found');
      setState(() {
        isLoading = false; // Set loading state to false if user not found
      });
    }
  }

  Future<Map<String, dynamic>?> fetchPackageData(String packageId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> packageSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_package')
              .doc(packageId)
              .get();

      if (packageSnapshot.exists) {
        // Package data retrieved successfully
        Map<String, dynamic> packageData = packageSnapshot.data()!;
        // Handle the package data as needed

        // Call fetchCourseData and await the result
        Map<String, dynamic>? courseAndCenterData =
            await fetchCourseData(packageData['course_id']);
        if (courseAndCenterData != null) {
          // Combine package and course/center data
          Map<String, dynamic> combinedData = {
            'package_data': packageData,
            'course_center_data': courseAndCenterData,
          };
          return combinedData;
        } else {
          print('Course or Center data not found');
        }
      } else {
        print('Package not found');
      }
    } catch (e) {
      print('Error fetching package data: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchCourseData(String courseId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> packageSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_course')
              .doc(courseId)
              .get();

      if (packageSnapshot.exists) {
        // Package data retrieved successfully
        Map<String, dynamic> packageData = packageSnapshot.data()!;
        // Handle the package data as needed
        print('Package data: $packageData');

        // Await the result of fetchCenterData
        Map<String, dynamic>? centerData =
            await fetchCenterData(packageData['center_id']);
        if (centerData != null) {
          // Combine package and center data
          Map<String, dynamic> combinedData = {
            'package_data': packageData,
            'center_data': centerData,
          };
          return combinedData;
        } else {
          print('Center data not found');
        }
      } else {
        print('Package not found');
      }
    } catch (e) {
      print('Error fetching package data: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchCenterData(String centerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> packageSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_center')
              .doc(centerId)
              .get();

      if (packageSnapshot.exists) {
        // Package data retrieved successfully
        Map<String, dynamic> packageData = packageSnapshot.data()!;
        // Handle the package data as needed
        // print('Package data: $packageData');
        // print('Package data: ${packageData['course_id']}');
        return {
          'center_name': packageData['center_name'],
          'center_email': packageData['center_email'],
          'center_contact': packageData['center_contact']
        };
      } else {
        print('Package not found');
      }
    } catch (e) {
      print('Error fetching package data: $e');
    }
    return null;
  }

  Future<void> cancel(id) async {
    try {
      await FirebaseFirestore.instance
          .collection('tbl_booking')
          .doc(id)
          .update({'booking_status': 2});
      print('Booking status updated successfully');
      Fluttertoast.showToast(
          msg: 'Cancelled',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      fetchData();
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  Future<void> sendEmail() async {
    final Uri uri = Uri.parse('YOUR_EMAIL_API_ENDPOINT');
    final response = await http.post(uri, body: {
      'to': 'recipient@example.com',
      'subject': 'Subject',
      'body': 'Body',
    });

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  Future<void> cancelBookingConfirmation(BuildContext context,id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Booking'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to cancel the booking
                cancel(id);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/pic3.jpg'), // Replace with your background image
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
                // Conditional rendering based on loading state
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(), // Loader
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: combinedDataList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> combinedData =
                              combinedDataList[index];
                          // Convert Timestamp to string
                          String bookingDateTime = combinedData['bookdata']
                                  ['booking_date_time']
                              .toDate()
                              .toString();
                          String centerName =
                              combinedData['packageAndCourseCenterData']
                                          ?['course_center_data']
                                      ?['center_data']?['center_name'] ??
                                  'Unknown';
                          String contact =
                              combinedData['packageAndCourseCenterData']
                                          ?['course_center_data']
                                      ?['center_data']?['center_contact'] ??
                                  'Unknown';
                          String email =
                              combinedData['packageAndCourseCenterData']
                                          ?['course_center_data']
                                      ?['center_data']?['center_email'] ??
                                  'Unknown';
                          String courseName =
                              combinedData['packageAndCourseCenterData']
                                          ?['course_center_data']
                                      ?['package_data']?['course_name'] ??
                                  'Unknown';
                          String packageName =
                              combinedData['packageAndCourseCenterData']
                                      ?['package_data']?['package_name'] ??
                                  'Unknown';
                          String cost =
                              combinedData['packageAndCourseCenterData']
                                          ?['package_data']?['package_cost']
                                      ?.toString() ??
                                  'Unknown';
                          String duration =
                              combinedData['packageAndCourseCenterData']
                                      ?['package_data']?['package_duration'] ??
                                  'Unknown';

                          return BookingDetailCard(
                            id:combinedData['bookdata']['id'],
                            bookingDateTime: bookingDateTime,
                            centerName: centerName,
                            contact: contact,
                            email: email,
                            courseName: courseName,
                            packageName: packageName,
                            cost: cost,
                            duration: duration,
                            cancelCallback: cancel, 
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingDetailCard extends StatelessWidget {
  final String id;
  final String bookingDateTime;
  final String centerName;
  final String contact;
  final String email;
  final String courseName;
  final String packageName;
  final String cost;
  final String duration;
final Function(String) cancelCallback;
  const BookingDetailCard({
    required this.bookingDateTime,
    required this.centerName,
    required this.contact,
    required this.email,
    required this.courseName,
    required this.packageName,
    required this.cost,
    required this.duration, required this.id, required this.cancelCallback,
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
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                cancelCallback(id);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(
                      255, 30, 54, 126), // Adjust button color as needed
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
