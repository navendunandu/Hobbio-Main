import 'package:flutter/material.dart';
import 'package:hobbio/view_center.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Search Centers',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Hobbio3',
                            ),
                          ),
                          SizedBox(height: 20.0),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'District',
                            ),
                            items: ['Ernakulam', 'District 2', 'District 3']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {},
                          ),
                          SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'City',
                            ),
                            items: ['Kothamangalam', 'City 2', 'City 3']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {},
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              // Add your submission logic here
                              // This function will be called when the button is pressed
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 65, 89, 124)), // Background color
                            ),
                            child: Center(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontFamily: 'Hobbio',
                                  fontSize: 17, // Font family
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Center Details',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Hobbio3',
                            ),
                          ),
                          SizedBox(height: 1.0),
                          ListView(
                            shrinkWrap: true,
                            children: [
                              CenterDetailTile(
                                name: 'Connect',
                              ),
                              CenterDetailTile(
                                name: 'Artistic',
                              ),
                              // Add more CenterDetailTile widgets as needed
                            ],
                          ),
                        ],
                      ),
                    ),
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

class CenterDetailTile extends StatelessWidget {
  final String name;

  const CenterDetailTile({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewCenter()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 65, 89, 124)),
        ),
        child: Text(
          'View',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Hobbio',
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}


