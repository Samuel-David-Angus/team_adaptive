import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';

import '../../../Module1_User_Management/Models/User.dart';

class StudentCourseOverviewView extends StatelessWidget {
  Course course;
  StudentCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    User? user = AuthServices().userInfo;
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(course.title!),
        Text(course.description!),
        ElevatedButton(
            onPressed: () {
              //todo
            },
            child: const Text('Lessons'))
      ],
    );
  }
}
