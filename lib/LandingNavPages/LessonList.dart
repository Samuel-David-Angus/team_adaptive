import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module3_Learner/Views/StudentLessonListView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonHomeView.dart';

class LessonListPage extends StatelessWidget {
  final Course course;
  const LessonListPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    var authChecker = Provider.of<AuthServices>(context);
    if (authChecker.userInfo == null) {
      return const Center(child: Text('Login to view lessons'));
    }
    return authChecker.userInfo!.type! == 'teacher'
        ? TeacherLessonHomeView(course: course)
        : StudentLessonListView(course: course);
  }
}
