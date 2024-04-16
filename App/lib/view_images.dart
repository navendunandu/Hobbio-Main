import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewImages extends StatefulWidget {
  final String id;

  const ViewImages({Key? key, required this.id}) : super(key: key);
  
  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  late Future<List<String>> imageUrlsFuture;

  @override
  void initState() {
    super.initState();
    imageUrlsFuture = fetchImageUrls(widget.id);
  }

  Future<List<String>> fetchImageUrls(String courseId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
          .instance
          .collection('tbl_gallery')
          .where('course_id', isEqualTo: courseId)
          .get();

      List<String> imageUrls = querySnapshot.docs
          .map((doc) => doc['gallery_image'].toString())
          .toList();

      return imageUrls;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/pic3.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Gallery',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Hobbio3',
                color: Color.fromRGBO(0, 1, 0, 1),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 10,
          right: 10,
          bottom: 10,
          child: FutureBuilder<List<String>>(
            future: imageUrlsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<String> imageUrls = snapshot.data ?? [];
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    imageUrls.length,
                    (index) => GalleryCard(imageUrl: imageUrls[index]),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class GalleryCard extends StatelessWidget {
  final String imageUrl;

  const GalleryCard({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
