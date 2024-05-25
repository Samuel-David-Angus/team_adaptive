

import 'package:flutter/cupertino.dart';

import '../../Module1_User_Management/Models/User.dart';
import '../../Module1_User_Management/Services/AuthServices.dart';
import '../Models/CourseModel.dart';
import '../Services/TeacherCourseServices.dart';

class TeacherCourseViewModel extends ChangeNotifier{
  TeacherCourseServices courseService = TeacherCourseServices();
  User? user;

  TeacherCourseViewModel() {
    // Initialize user with current value from AuthServices
    user = AuthServices().userInfo;

    // Listen to changes in AuthServices
    AuthServices().addListener(_updateUser);
  }

  void _updateUser() {
    user = AuthServices().userInfo;
    notifyListeners();
  }

  Future<List<Course>?> getCourses() async {
    if (user != null) {
      return await courseService.getCourses(user!);
    }
    return null;
  }

  Future<bool> addCourse(Course course) async {
    return await courseService.addCourse(course);
  }

  Future<bool> joinCourse(String courseID) async {
    return await courseService.joinCourse(courseID, user!);
  }

  bool validate(String title, String code, String description) {
    return title.isNotEmpty && code.isNotEmpty && description.isNotEmpty;
  }
}