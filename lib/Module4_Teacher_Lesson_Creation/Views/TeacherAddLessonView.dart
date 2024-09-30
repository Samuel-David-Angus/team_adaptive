import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLearningOutcomesView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLearningOutcomesViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../Module2_Courses/Models/CourseModel.dart';

class TeacherAddLessonView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Course course;
  final TeacherAddLearningOutcomesViewModel
      teacherAddLearningOutcomesViewModel =
      TeacherAddLearningOutcomesViewModel();
  TeacherAddLessonView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<TeacherLessonViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 3 - 20,
          height: MediaQuery.of(context).size.height / 2 - 40,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Add Lesson",
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Title'),
                  controller: titleController,
                ),
                const SizedBox(height: 30.0),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Description'),
                  controller: descriptionController,
                  maxLines: 10,
                ),
                const SizedBox(height: 50.0),
                ChangeNotifierProvider.value(
                  value: teacherAddLearningOutcomesViewModel,
                  child: TeacherAddLearningObjectivesView(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 150.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (teacherAddLearningOutcomesViewModel
                                    .learningOutcomes.isNotEmpty &&
                                titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              await viewModel.addLesson(
                                  titleController.text,
                                  descriptionController.text,
                                  course.id!,
                                  teacherAddLearningOutcomesViewModel
                                      .learningOutcomes);
                              viewModel.allLessons =
                                  viewModel.getLessonByCourse(course.id!);
                              viewModel.refresh();
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Message'),
                                    content: const Text(
                                        'Pls fill all fields and select concepts'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ThemeColor.darkgreyTheme, // Padding
                          ),
                          child: const Text('Save',
                              style:
                                  TextStyle(color: ThemeColor.offwhiteTheme)),
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
