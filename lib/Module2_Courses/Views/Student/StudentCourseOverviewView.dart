import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module3_Learner/Views/StudentLessonListView.dart';

import '../../../Module1_User_Management/Models/User.dart';

class StudentCourseOverviewView extends StatelessWidget {
  Course course;
  StudentCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    User? user = AuthServices().userInfo;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Course Title: ${course.title!}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Course Description: ${course.description!}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Course Code: ${course.code!}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentLessonListView(course: course))
                );
              },
              child: const Text('Lessons'))
        ],
      ),
    );
  }
}
