import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Hobbio/view_images.dart';
import 'package:Hobbio/view_packages.dart'; // Import FirebaseAuth if you're using Firebase Authentication

class ViewCenter extends StatefulWidget {
  final String id;
  final String title;

  const ViewCenter({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<ViewCenter> createState() => _ViewCenterState();
}

class _ViewCenterState extends State<ViewCenter> {
  late Future<List<Map<String, dynamic>>> courseListFuture;

  @override
  void initState() {
    super.initState();
    courseListFuture = fetchCourses(widget.id);
  }

  Future<List<Map<String, dynamic>>> fetchCourses(String centerId) async {
  try {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('tbl_course')
            .where('center_id', isEqualTo: centerId)
            .get();

    List<Map<String, dynamic>> courses = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> courseData = {
        'id': doc.id,
        'courseName': doc['course_name'].toString(),
        'courseDescription': doc['course_des'].toString(),
      };

      // Check if the course is in favorites
      if (userId != null) {
        courseData['isFavorite'] = await isCourseFavorite(doc.id);
      } else {
        // If the user is not logged in, set isFavorite to false
        courseData['isFavorite'] = false;
      }

      courses.add(courseData);
    }

    return courses;
  } catch (e) {
    print('Error fetching courses: $e');
    return [];
  }
}



  Future<void> toggleFavorite(String courseId) async {
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
        
        // Reference to the document in the 'tbl_favorites' collection
        QuerySnapshot<Map<String, dynamic>> favoritesRef = await FirebaseFirestore.instance
            .collection('tbl_favorites')
            .where("course_id", isEqualTo: courseId)
            .where("user_id", isEqualTo: uDoc)
            .get();

        // Check if the course is already in favorites
        if (favoritesRef.docs.isNotEmpty) {
          // Course is already in favorites, delete it
          await favoritesRef.docs.first.reference.delete();
        } else {
          // Course is not in favorites, add it
          await FirebaseFirestore.instance.collection('tbl_favorites').add({
            'user_id': uDoc,
            'course_id': courseId,
          });
        }
      } else {
        print("User document not found.");
      }
    } else {
      print("User ID not found.");
    }
  } catch (e) {
    print('Error toggling favorite: $e');
  }
}

Future<bool> isCourseFavorite(String courseId) async {
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
        
        // Reference to the document in the 'tbl_favorites' collection
        QuerySnapshot<Map<String, dynamic>> favoritesRef = await FirebaseFirestore.instance
            .collection('tbl_favorites')
            .where("course_id", isEqualTo: courseId)
            .where("user_id", isEqualTo: uDoc)
            .get();
        if (favoritesRef.docs.isNotEmpty) {
          return true;
        }
        else{
          return false;
        }
        // Return true if the course is in favorites, false otherwise
        
      } else {
        print("User document not found.");
        return false;
      }
    } else {
      print("User ID not found.");
      return false;
    }
  } catch (e) {
    print('Error checking favorite: $e');
    return false;
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/pic3.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: courseListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> courses = snapshot.data ?? [];
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        widget.title, // Add your center name here
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hobbio3',
                          color: Color.fromRGBO(0, 1, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  ...courses.map((course) {
                    return CenterCard(
                      courseId: course['id'],
                      courseName: course['courseName'],
                      courseDescription: course['courseDescription'],
                      toggleFavorite: toggleFavorite,
                      isFavorite:course['isFavorite'],
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

class CenterCard extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String courseDescription;
  final bool isFavorite;
  final Future<void> Function(String) toggleFavorite;
  CenterCard({
    required this.courseName,
    required this.courseDescription,
    required this.courseId,
    required this.toggleFavorite, required this.isFavorite,
  });

  @override
  _CenterCardState createState() => _CenterCardState();
}

class _CenterCardState extends State<CenterCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

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
              widget.courseName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.courseDescription,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPackages(
                                id: widget.courseId,
                                title: widget.courseName,
                              )),
                    );
                    // View Packages Logic
                  },
                  child: Text('View Packages'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewImages(
                                id: widget.courseId,
                              )),
                    );
                    // View Images Logic
                  },
                  child: Text('View Images'),
                ),
              ],
            ),
            // Like Button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () async {
                setState(() {
                  isFavorite = !isFavorite; // Toggle favorite status
                });
                await widget.toggleFavorite(widget.courseId); // Update Firestore
              },
            ),
          ],
        ),
      ),
    );
  }
}
