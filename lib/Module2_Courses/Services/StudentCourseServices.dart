
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Module1_User_Management/Models/User.dart';
import '../Models/CourseModel.dart';

class StudentCourseServices {
  static final StudentCourseServices _instance = StudentCourseServices._internal();

  factory StudentCourseServices() {
    return _instance;
  }

  StudentCourseServices._internal();

  Future<List<Course>?> getCourses(User user) async {
    List<Course> courses = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Course')
          .where('students', arrayContains: user.id)
          .withConverter<Course>(
            fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        courses.add(snapshot.data() as Course);
      }
      return courses;

    } catch (e) {
      print('Error getting courses: $e');
    }
    return null;
  }

  Future<bool> enrollCourse(String courseID, User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('Course')
          .doc(courseID)
          .update({'students': FieldValue.arrayUnion([user.id])});
      return true;
    } catch (e) {
      print('Error in enrolling: $e');
    }
    return false;
  }

  Future<Course?> getCourseByID(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Course')
          .doc(id)
          .withConverter<Course>(
          fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        return data as Course;
      }
    } catch (e) {
      print('Error getting course: $e');
    }
    return null;

  }


}