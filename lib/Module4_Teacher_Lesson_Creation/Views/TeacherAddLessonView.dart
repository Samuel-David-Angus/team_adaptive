import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherSelectConceptsView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../Module2_Courses/Models/CourseModel.dart';
import '../View_Models/SelectConceptsViewModel.dart';

class TeacherAddLessonView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Course course;
  final SelectConceptsViewModel selectConceptsViewModel =
      SelectConceptsViewModel();
  TeacherAddLessonView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<TeacherLessonViewModel>(context, listen: false);
    List<String>? selectedItems;
    return AlertDialog(
      title: const Text('Add Lesson'),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3 - 20,
          height: MediaQuery.of(context).size.height / 2 - 40,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          selectedItems = await showDialog<List<String>>(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangeNotifierProvider.value(
                                value: selectConceptsViewModel,
                                child: TeacherSelectConceptsView(
                                  courseID: course.id,
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Concepts')
                      )
                    ),
                    SizedBox(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedItems != null) {
                            if (selectedItems!.isNotEmpty &&
                                titleController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              await viewModel.addLesson(
                                  titleController.text,
                                  descriptionController.text,
                                  course.id!,
                                  selectedItems!);
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Message'),
                                    content:
                                        const Text('Pls fill all fields and select concepts'),
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
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.darkgreyTheme,// Padding
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: ThemeColor.offwhiteTheme)
                        ),
                      )
                    )
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
