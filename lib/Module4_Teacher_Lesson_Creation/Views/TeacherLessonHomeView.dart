import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonMaterialHomeView.dart';

import '../../Components/TemplateView.dart';
import '../../Components/TopRightOptions.dart';

class TeacherLessonHomeView extends StatelessWidget {
  Course course;
  TeacherLessonHomeView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final TeacherLessonViewModel viewModel = Provider.of<TeacherLessonViewModel>(context, listen: false);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<List<LessonModel>>(
            future: viewModel.getLessonByCourse(course.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or any loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<LessonModel> lessons = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TeacherAddLessonView(course: course);
                              }
                          );
                        },
                        child: const Text('Add Lesson')),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                          lessons.length,
                              (index) {
                            return Card(
                                child: ListTile(
                                  title: Text(lessons[index].lessonTitle!),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => TeacherLessonMaterialHomeView(lesson: lessons[index])));
                                        },
                                        child: const Text('See materials'),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
