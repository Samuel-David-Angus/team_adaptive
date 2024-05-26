import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Views/LoginView.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/Views/Student/StudentCourseOverviewView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherCourseOverviewView.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

class CourseOverviewPage extends StatelessWidget {
  Course course;
  CourseOverviewPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    String? type = authServices.userInfo?.type;
    if (authServices.currentUser == null || type == null || course == null) {
      return const LoginView();
    }
    return type == 'teacher' ? TeacherCourseOverviewView(course: course) : StudentCourseOverviewView(course: course);
  }
}
