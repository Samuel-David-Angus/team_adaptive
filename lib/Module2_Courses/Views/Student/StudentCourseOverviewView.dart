import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';


class StudentCourseOverviewView extends StatelessWidget {
  final Course course;
  StudentCourseOverviewView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
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
                GoRouter.of(context).go('/courses/${course.id}/lessons', extra: course);
              },
              child: const Text('Lessons'))
        ],
      ),
    );
  }
}
