import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonHomeView.dart';

import '../../../Module1_User_Management/Models/User.dart';
import '../../../Module1_User_Management/Services/AuthServices.dart';

class TeacherCourseOverviewView extends StatelessWidget {
  Course course;
  TeacherCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    User? user = AuthServices().userInfo;
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Course Title: ${course.title!}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Course Description: ${course.description!}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Course Code: ${course.code!}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Course ID: ${course.id!}',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TeacherLessonHomeView(course: course)));
                  },
                  child: const Text('Lessons')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/conceptMap',
                        arguments: course);
                  },
                  child: const Text('View Concept Map'))
            ],
          ),
        ));
  }
}
