import 'package:flutter/material.dart';

class ViewImages extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/karate1.jpg',
    'assets/karate2.jpg',
    // Add more image URLs here
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/pic3.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Gallery heading
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
                decoration: TextDecoration.none, // Remove underlines
              ),
            ),
          ),
        ),
        // Gallery images
        Positioned(
          top: 100,
          left: 10,
          right: 10,
          bottom: 10,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(
              imageUrls.length,
              (index) => GalleryCard(imageUrl: imageUrls[index]),
            ),
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
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
