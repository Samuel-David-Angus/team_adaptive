import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherSelectConceptsView.dart';

import '../../Module2_Courses/Models/CourseModel.dart';
import '../View_Models/SelectConceptsViewModel.dart';

class TeacherAddLessonView extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Add Lesson'),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Description'),
              controller: descriptionController,
            ),
            ElevatedButton(
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
                child: const Text('Concepts')),
            const SizedBox(
              height: 20,
            ),
            TextButton(
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
                            title: Text('Message'),
                            content:
                                Text('Pls fill all fields and select concepts'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
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
                child: Text('Save'))
          ],
        ),
      ),
    );
  }
}
