import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherSelectLearningStyleView.dart';
import '../View_Models/SelectLearningStyleViewModel.dart';

import '../View_Models/TeacherLessonViewModel.dart';
import 'TeacherSelectConceptsView.dart';
import '../View_Models/SelectConceptsViewModel.dart';

class TeacherAddLessonMaterialView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final LessonModel lesson;

  final String type;
  final SelectConceptsViewModel selectConceptsViewModel =
      SelectConceptsViewModel();
  final SelectLearningStyleViewModel selectLearningStyleViewModel =
      SelectLearningStyleViewModel();
  TeacherAddLessonMaterialView(
      {super.key, required this.type, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<TeacherLessonViewModel>(context, listen: false);
    List<String>? selectedConcepts;
    String? learningStyle;
    return AlertDialog(
      title: Text('Add material'),
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Upload'),
              controller: linkController,
            ),
            ElevatedButton(
                onPressed: () async {
                  selectedConcepts = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                          value: selectConceptsViewModel,
                          child: TeacherSelectConceptsView(lesson: lesson));
                    },
                  );
                },
                child: const Text('Concepts')),
            ElevatedButton(
                onPressed: () async {
                  learningStyle = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                          value: selectLearningStyleViewModel,
                          child: const TeacherSelectLearningStyleView());
                    },
                  );
                },
                child: const Text('Learning Styles')),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  if (selectedConcepts != null) {
                    if (selectedConcepts!.isNotEmpty &&
                        titleController.text.isNotEmpty &&
                        linkController.text.isNotEmpty) {
                      await viewModel.addLessonMaterial(
                          lesson.courseID!,
                          lesson.id!,
                          titleController.text,
                          AuthServices().userInfo!.id!,
                          linkController.text,
                          learningStyle!,
                          selectedConcepts!,
                          type);
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
