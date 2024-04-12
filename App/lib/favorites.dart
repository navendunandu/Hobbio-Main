import 'package:flutter/material.dart';
import 'package:hobbio/view_center.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic3.jpg'), // Replace with your background image
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
            fontFamily: 'Hobbio3',// Replace with your font family
                       // Adjust text color as needed
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FavoriteCard(
                    courseName: 'Kungfu Masters', // Replace with course name
                    centerName: 'Artistic', // Replace with center name
                  ),
                  
                  // Add more FavoriteCard widgets as needed
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
  final String centerName;

  const FavoriteCard({
    required this.courseName,
    required this.centerName,
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
            SizedBox(height: 10.0),
            Text(
              'Center: $centerName',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Remove button logic
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 30, 54, 126), // Adjust button color as needed
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
                            builder: (e) => ViewCenter(),
                          ),
                        );
                    // View more button logic
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 63, 151, 219), // Adjust button color as needed
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
