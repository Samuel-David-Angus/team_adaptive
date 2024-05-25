import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Services/StudentCourseServices.dart';

import '../../Module1_User_Management/Models/User.dart';
import '../Models/CourseModel.dart';

class StudentCourseViewModel extends ChangeNotifier {
    StudentCourseServices courseService = StudentCourseServices();
    User? user;

    StudentCourseViewModel() {
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

    Future<bool> enroll(String courseID) async {
        return await courseService.enrollCourse(courseID, user!);
    }

    bool validate(String courseID) {
        return courseID.isNotEmpty;
    }
}