import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonMaterialView.dart';

import '../View_Models/TeacherLessonViewModel.dart';

class TeacherLessonMaterialListView extends StatelessWidget {
  LessonModel lesson;
  String type;
  TeacherLessonMaterialListView({super.key, required this.lesson, required this.type});

  @override
  Widget build(BuildContext context) {
    final TeacherLessonViewModel viewModel = Provider.of<TeacherLessonViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<List<LessonMaterialModel>>(
        future: viewModel.getLessonMaterialsByType(lesson.courseID!, lesson.id!, type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or any loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<LessonMaterialModel> materials = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TeacherAddLessonMaterialView(type: type, lesson: lesson);
                          }
                      );
                    },
                    child: Text('Add $type lesson')),
                Wrap(
                  spacing: 10,
                  children: List.generate(
                      materials.length,
                          (index) {
                        return Card(
                            child: ListTile(
                              title: Text(materials[index].title!),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {

                                    },
                                    child: const Text('View'),
                                  ),
                                  TextButton(
                                    onPressed: () {

                                    },
                                    child: const Text('Edit'),
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
    );
  }
}
