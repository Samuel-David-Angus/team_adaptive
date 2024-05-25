import 'package:flutter/material.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';

class TeacherCourseOverviewView extends StatelessWidget {
  Course course;
  TeacherCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(course.title!),
        Text(course.description!),
        Text(course.id!),
        ElevatedButton(
            onPressed: () {
              //todo
            },
            child: const Text('Lessons')),
        ElevatedButton(
            onPressed: () {
              //todo
            },
            child: const Text('Concept Map'))
      ],
    );
  }
}
