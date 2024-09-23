import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonMaterialHomeView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../Module6_Teacher_Assessment_Creation/Views/TeacherViewQuestionView.dart';
import './InitialAddMaterialsView.dart';

class TeacherLessonHomeView extends StatelessWidget {
  final Course course;
  bool justLoaded = true;
  TeacherLessonHomeView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final TeacherLessonViewModel viewModel =
        Provider.of<TeacherLessonViewModel>(context);
    if (justLoaded) {
      justLoaded = false;
      viewModel.allLessons = viewModel.getLessonByCourse(course.id!);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<LessonModel>>(
        future: viewModel.allLessons,
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
                const SizedBox(height: 50.0),
                SizedBox(
                  width: 150.0,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return viewModel.canAddMoreLessons
                                ? TeacherAddLessonView(course: course)
                                : AlertDialog(
                                    title: const Text('OOPS!'),
                                    content: const Text(
                                        'You cannot add more lessons if the latest lesson setup is incomplete'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.darkgreyTheme,
                    ),
                    child: const Text(
                      '+ Add Lesson',
                      style: TextStyle(
                        color: ThemeColor.offwhiteTheme,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                Wrap(
                  spacing: 10,
                  children: List.generate(lessons.length, (index) {
                    return Card(
                        child: ListTile(
                      title: Text(lessons[index].lessonTitle!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).go(
                                  '/courses/${course.id}/lessons/${lessons[index].id}/materials',
                                  extra: lessons[index]);
                            },
                            child: const Text('See materials'),
                          ),
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).go(
                                  '/courses/${course.id}/lessons/${lessons[index].id}/questions',
                                  extra: lessons[index]);
                            },
                            child: const Text('Create Assessment Questions'),
                          ),
                          if (!lessons[index].isSetupComplete!)
                            TextButton(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InitialAddMaterialsView(
                                                  lesson: lessons[index])));
                                  viewModel.refresh();
                                },
                                child: const Text('Setup'))
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
    );
  }
}
