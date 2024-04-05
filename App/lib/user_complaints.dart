import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaints',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserComplaints(),
    );
  }
}

class UserComplaints extends StatelessWidget {
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
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 400.0, // Adjust the height as needed
                child: ComplaintsFormCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintsFormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ComplaintsForm(),
      ),
    );
  }
}

class ComplaintsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report your complaints here...',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Hobbio3',
          ),
        ),
        SizedBox(height: 20.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Complaint Title',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Complaint Content',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            // Add your submission logic here
            // This function will be called when the button is pressed
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 65, 89, 124),
            ), // Background color
          ),
          child: Center(
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // Text color
                fontFamily: 'Hobbio',
                fontSize: 17, // Font family
              ),
            ),
          ),
        ),
      ],
    );
  }
}
