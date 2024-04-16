import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Hobbio/view_center.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> district = [];
  List<Map<String, dynamic>> city = [];
  String? selectdistrict;
  String? selectcity;
  List<Map<String, dynamic>> center = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchDistrict();
    fetchCenter();
    searchCenter();
  }

  Future<void> fetchDistrict() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('tbl_district').get();

      List<Map<String, dynamic>> dist = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'district': doc['district_name'].toString(),
              })
          .toList();
      setState(() {
        district = dist;
      });
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }

  Future<void> fetchCity(String id) async {
    try {
      selectcity = null;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_city')
              .where('district_id', isEqualTo: id)
              .get();
      List<Map<String, dynamic>> plc = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'city': doc['city_name'].toString(),
              })
          .toList();
      setState(() {
        city = plc;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCenter() async {
    try {
      QuerySnapshot<Map<String, dynamic>> centerSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_center')
              .where('center_status', isEqualTo: 1)
              .get();
      List<Map<String, dynamic>> centerList = centerSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['center_name'].toString(),
              })
          .toList();

      setState(() {
        center = centerList;
      });
      print("center: $center");
    } catch (e) {
      print('Error fetching center data: $e');
    }
  }

  Future<void> searchCenter() async {
    try {
      QuerySnapshot<Map<String, dynamic>> centerSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_center')
              .where('center_status', isEqualTo: 1)
              .where('city_id', isEqualTo: selectcity)
              .get();
      List<Map<String, dynamic>> centerList = centerSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['center_name'].toString(),
              })
          .toList();

      setState(() {
        center = centerList;
      });
    } catch (e) {
      print('Error fetching center data: $e');
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
                image: AssetImage('assets/pic3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select a District';
                                }
                                return null;
                              },
                              value: selectdistrict,
                              decoration: InputDecoration(
                                label: const Text('District'),
                                hintText: 'Select District',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectdistrict = newValue;
                                  fetchCity(newValue!);
                                });
                              },
                              isExpanded: true,
                              items: district.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> dist) {
                                  return DropdownMenuItem<String>(
                                    value: dist['id'],
                                    child: Text(dist['district']),
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select the City';
                                }
                                return null;
                              },
                              value: selectcity,
                              decoration: InputDecoration(
                                label: const Text('City'),
                                hintText: 'Select City',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectcity = newValue;
                                });
                              },
                              isExpanded: true,
                              items: city.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> city) {
                                  return DropdownMenuItem<String>(
                                    value: city['id'],
                                    child: Text(city['city']),
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  searchCenter();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 65, 89, 124)),
                              ),
                              child: Center(
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Hobbio',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectcity = null;
                                  selectdistrict = null;
                                });
                                fetchCenter();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 65, 89, 124)),
                              ),
                              child: Center(
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Hobbio',
                                    fontSize: 17,
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: center.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CenterDetailTile(
                                  id: center[index]['id'],
                                  name: center[index]['name'],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CenterDetailTile extends StatelessWidget {
  final String id;
  final String name;

  const CenterDetailTile({
    super.key,
    required this.id,
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
            MaterialPageRoute(builder: (context) => ViewCenter(id: id,title: name,)),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 65, 89, 124)),
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
