import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingData {
  final String bookingId;
  final String packageId;

  BookingData({
    required this.bookingId,
    required this.packageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'packageId': packageId,
    };
  }
}

class PackageData {
  final String packageId;
  final String courseId;

  PackageData({
    required this.packageId,
    required this.courseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'courseId': courseId,
    };
  }
}

class CourseData {
  final String courseId;
  final String centerId;

  CourseData({
    required this.courseId,
    required this.centerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'centerId': centerId,
    };
  }
}

class CenterData {
  final String centerId;
  // Add other fields as needed

  CenterData({
    required this.centerId,
    // Add other fields as needed
  });

  Map<String, dynamic> toJson() {
    return {
      'centerId': centerId,
      // Add other fields as needed
    };
  }
}

Future<List<Map<String, dynamic>>> fetchUserData() async {
  List<Map<String, dynamic>> combinedData = [];

  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
     QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('tbl_user')
          .where('user_id', isEqualTo: userId)
          .get();
          String uDoc = userSnapshot.docs.first.id;
    // Fetch data from tbl_booking
    QuerySnapshot<Map<String, dynamic>> bookingSnapshot =
        await FirebaseFirestore.instance
            .collection('tbl_booking')
            .where('user_id', isEqualTo: uDoc)
            .get();

    // Iterate over each document in the booking snapshot
    for (QueryDocumentSnapshot<Map<String, dynamic>> bookingDoc
        in bookingSnapshot.docs) {
      // Get package_id from tbl_booking
      String packageId = bookingDoc['package_id'];

      // Fetch data from tbl_package using package_id
      DocumentSnapshot<Map<String, dynamic>> packageSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_package')
              .doc(packageId)
              .get();

      // Get course_id from tbl_package
      String courseId = packageSnapshot['course_id'];

      // Fetch data from tbl_course using course_id
      DocumentSnapshot<Map<String, dynamic>> courseSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_course')
              .doc(courseId)
              .get();

      // Get center_id from tbl_course
      String centerId = courseSnapshot['center_id'];

      // Fetch data from tbl_center using center_id
      DocumentSnapshot<Map<String, dynamic>> centerSnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_center')
              .doc(centerId)
              .get();

      // Create objects of respective model classes
      BookingData bookingData = BookingData(
        bookingId: bookingDoc.id,
        packageId: packageId,
      );

      PackageData packageData = PackageData(
        packageId: packageId,
        courseId: courseId,
      );

      CourseData courseData = CourseData(
        courseId: courseId,
        centerId: centerId,
      );

      CenterData centerData = CenterData(
        centerId: centerId,
        // Add other fields as needed
      );

      // Convert objects to Map and add them to the combined list
      combinedData.add(bookingData.toJson());
      combinedData.add(packageData.toJson());
      combinedData.add(courseData.toJson());
      combinedData.add(centerData.toJson());
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }

  return combinedData;
}
