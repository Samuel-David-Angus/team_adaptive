import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

import '../View_Models/TeacherLessonViewModel.dart';
import 'TeacherSelectConceptsView.dart';

class TeacherAddLessonMaterialView extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  LessonModel lesson;

  String type;
  TeacherAddLessonMaterialView({super.key, required this.type, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TeacherLessonViewModel>(context, listen: false);
    return AlertDialog(
      title: Text('Add material'),
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration (
                  border: OutlineInputBorder(),
                  hintText: 'Title'
              ),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration (
                  border: OutlineInputBorder(),
                  hintText: 'Upload'
              ),
              controller: linkController,
            ),
            ElevatedButton(
                onPressed: () async {
                  final List<String>? selectedItems = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      return TeacherSelectConceptsView(
                        lesson: lesson,
                      );
                    },
                  );
                  if (selectedItems != null) {
                    if (selectedItems.isNotEmpty && titleController.text.isNotEmpty && linkController.text.isNotEmpty) {
                      //viewModel.addLessonMaterial(lesson.courseID!, AuthServices().userInfo!.id!, titleController.text, descriptionController.text, course.id!, selectedItems);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Message'),
                            content: Text('Pls fill all fields and select concepts'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }

                },
                child: const Text('Concepts'))
          ],
        ),
      ),
    );
  }
}
