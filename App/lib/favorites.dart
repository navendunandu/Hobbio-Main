import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Hobbio/view_center.dart';
import 'package:Hobbio/view_packages.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoritesList = [];
  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    List<Map<String, dynamic>> fetchedFavorites = [];

    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('tbl_user')
          .where('user_id', isEqualTo: userId)
          .get();
      String uDoc = userSnapshot.docs.first.id;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tbl_favorites')
          .where('user_id', isEqualTo: uDoc)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await Future.forEach(querySnapshot.docs, (doc) async {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null) {
            String? courseId = data['course_id'];
            String documentId = doc.id;
            String courseName = await fetchCourseName(courseId!);
            fetchedFavorites.add({
              'course_id': courseId,
              'course_name': courseName,
              'documentId': documentId,
            });
          }
        });

        setState(() {
          favoritesList = fetchedFavorites;
        });
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      // Handle error here if necessary
    }
  }

  Future<String> fetchCourseName(String courseId) async {
    try {
      DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('tbl_course')
          .doc(courseId)
          .get();

      if (courseSnapshot.exists) {
        Map<String, dynamic>? data =
            courseSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          return data['course_name'];
        }
      }
    } catch (e) {
      print('Error fetching course name: $e');
      // Handle error here if necessary
    }
    return ''; // Return empty string if course name not found or error occurs
  }

  void removeFromFavorites(String documentId) async {
    try {
      print("Removing");
      // Remove document from Firestore
      await FirebaseFirestore.instance
          .collection('tbl_favorites')
          .doc(documentId)
          .delete();

      // Remove item from favoritesList
     fetchFavorites();
      print("Removied");
    } catch (e) {
      print('Error removing favorite: $e');
      // Handle error here if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/pic3.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30.0),
                  Text(
                    'Your Favorites',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Hobbio3', // Replace with your font family
                      // Adjust text color as needed
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Display FavoriteCards using data from favoritesList
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoritesList.length,
                    itemBuilder: (context, index) {
                      return FavoriteCard(
                        id: favoritesList[index]
                            ['documentId'], // Use 'course_id' instead of 'id'
                        courseName: favoritesList[index]['course_name'],
                        removeFromFavorites: removeFromFavorites,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final String courseName;
  final String id;
  final Function(String) removeFromFavorites; // Callback function

  const FavoriteCard({
    required this.courseName,
    required this.id,
    required this.removeFromFavorites,
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
              'Course: $courseName',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Remove button logic
                    removeFromFavorites(id);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 30, 54, 126), // Adjust button color as needed
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white, // Adjust button text color as needed
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewPackages(id: id, title: courseName),
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 63, 151, 219), // Adjust button color as needed
                    ),
                  ),
                  child: Text(
                    'View More',
                    style: TextStyle(
                      color: Colors.white, // Adjust button text color as needed
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
