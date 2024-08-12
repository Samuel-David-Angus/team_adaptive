import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonMaterialHomeView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../Components/TemplateView.dart';
import '../../Components/TopRightOptions.dart';
import '../../Module6_Teacher_Assessment_Creation/Views/TeacherViewQuestionView.dart';
import './InitialAddMaterialsView.dart';

class TeacherLessonHomeView extends StatelessWidget {
  final Course course;
  const TeacherLessonHomeView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final TeacherLessonViewModel viewModel =
        Provider.of<TeacherLessonViewModel>(context);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 50.0),
                    ElevatedButton(
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
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            '+ Add Lesson',
                            style: TextStyle(
                              color: ThemeColor.offwhiteTheme,
                              fontSize: 20.0,
                            ),
                          ),
                        )
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeacherLessonMaterialHomeView(
                                                  lesson: lessons[index])));
                                },
                                child: const Text('See materials'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeacherViewQuestionView(
                                                  lesson: lessons[index])));
                                },
                                child:
                                    const Text('Create Assessment Questions'),
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
        ));
  }
}
