import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Services/StudentCourseServices.dart';

import '../../Module1_User_Management/Models/User.dart';
import '../Models/CourseModel.dart';

class StudentCourseViewModel extends ChangeNotifier {
    StudentCourseServices courseService = StudentCourseServices();



    Future<List<Course>?> getCourses() async {
        if (AuthServices().userInfo != null) {
            return await courseService.getCourses(AuthServices().userInfo!);
        }
        return null;
    }

    Future<bool> enroll(String courseID) async {
        return await courseService.enrollCourse(courseID, AuthServices().userInfo!);
    }

    bool validate(String courseID) {
        return courseID.isNotEmpty;
    }

}