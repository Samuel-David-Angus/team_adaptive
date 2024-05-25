
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Module1_User_Management/Models/User.dart';
import '../Models/CourseModel.dart';

class TeacherCourseServices {
  static final TeacherCourseServices _instance = TeacherCourseServices._internal();

  factory TeacherCourseServices() {
    return _instance;
  }
  TeacherCourseServices._internal();

  Future<List<Course>?> getCourses(User user) async {
    List<Course> courses = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Course')
          .where('teachers', arrayContains: user.id)
          .withConverter<Course>(
            fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
            toFirestore: (course, _) => course.toJson())
          .get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        courses.add(snapshot.data() as Course);
      }
      return courses;

    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<bool> addCourse(Course course) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('Course')
          .withConverter<Course>(
          fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
          toFirestore: (course, _) => course.toJson());
      if (course.id == null) {
        await ref.add(course);
      } else {
        await ref.doc(course.id).set(course);
      }
      return true;
    } catch (e) {
      print('Error adding course: $e');
    }
    return false;
  }

  Future<bool> joinCourse(String courseID, User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('Course')
          .doc(courseID)
          .update({'teachers': FieldValue.arrayUnion([user.id])});
      return true;
    } catch (e) {
      print('Error joining course: $e');
    }
    return false;
  }

}