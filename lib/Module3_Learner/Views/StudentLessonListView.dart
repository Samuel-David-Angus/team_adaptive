import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module3_Learner/Views/ViewLessonView.dart';

import '../../Components/TemplateView.dart';
import '../../Components/TopRightOptions.dart';
import '../../Module2_Courses/Models/CourseModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class StudentLessonListView extends StatelessWidget {
  Course course;
  StudentLessonListView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final StudentLessonViewModel viewModel = Provider.of<StudentLessonViewModel>(context, listen: false);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<LessonModel>>(
            future: viewModel.getCourseLessons(course.id!),
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
                                              MaterialPageRoute(builder: (context) => ViewLessonView(lesson: lessons[index])));
                                        },
                                        child: const Text('Take Lesson'),
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