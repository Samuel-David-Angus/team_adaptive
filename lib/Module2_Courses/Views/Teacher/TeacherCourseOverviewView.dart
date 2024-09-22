import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonHomeView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../../Module1_User_Management/Models/User.dart';
import '../../../Module1_User_Management/Services/AuthServices.dart';

class TeacherCourseOverviewView extends StatelessWidget {
  Course course;
  TeacherCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    User? user = AuthServices().userInfo;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Course Title: ${course.title!}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30.0),
          const Text(
            'Course Description:',
            style: TextStyle(fontSize: 20),
          ),
          if(course.description != '')
            Text(
              course.description!,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          const SizedBox(height: 10),
          Text(
            'Course Code: ${course.code!}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Course ID: ${course.id!}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 50.0),
          SizedBox(
            width: 500.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/courses/${course.id}/lessons');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.darkgreyTheme,
              ),
              child: const Text(
                'Lessons',
                style: TextStyle(color: ThemeColor.offwhiteTheme),
              )
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 500.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/conceptMap');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.offwhiteTheme,
              ),
              child: const Text(
                'View Concept Map',
                style: TextStyle(color: ThemeColor.darkgreyTheme),
              )
            )
          )
        ],
      ),
    );
  }
}
