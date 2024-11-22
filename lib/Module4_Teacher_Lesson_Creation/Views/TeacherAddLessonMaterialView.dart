import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/AtomicInputMaterialInfoViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/InitialAddMaterialsViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/AtomicInputMaterialInfoView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherSelectLearningStyleView.dart';

import '../View_Models/SelectConceptsViewModel.dart';
import '../View_Models/SelectLearningStyleViewModel.dart';
import 'TeacherSelectConceptsView.dart';

class TeacherAddLessonMaterialView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final LessonModel lesson;

  final String type;
  final SelectConceptsViewModel selectConceptsViewModel =
      SelectConceptsViewModel();
  final SelectLearningStyleViewModel selectLearningStyleViewModel =
      SelectLearningStyleViewModel();
  final InitialAddMaterialsViewModel initialAddMaterialsViewModel =
      InitialAddMaterialsViewModel();
  TeacherAddLessonMaterialView(
      {super.key, required this.type, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: initialAddMaterialsViewModel,
      child: Consumer<InitialAddMaterialsViewModel>(
          builder: (context, viewModel, child) {
        return AlertDialog(
          title: const Text('Add material'),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      List<String>? selectedConcepts =
                          await showDialog<List<String>>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider.value(
                              value: selectConceptsViewModel,
                              child: TeacherSelectConceptsView(lesson: lesson));
                        },
                      );
                      if (selectedConcepts == null ||
                          selectedConcepts.isEmpty) {
                        viewModel.initialMaterials.clear();
                      }
                      viewModel.refresh();
                    },
                    child: const Text('Concepts')),
                ElevatedButton(
                    onPressed: () async {
                      String? learningStyle = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider.value(
                              value: selectLearningStyleViewModel,
                              child: const TeacherSelectLearningStyleView());
                        },
                      );
                      if (learningStyle != null) {
                        viewModel.initialMaterials.clear();
                      }
                      viewModel.refresh();
                    },
                    child: const Text('Learning Styles')),
                const SizedBox(
                  height: 20,
                ),
                if (selectLearningStyleViewModel.selectedStyle.isNotEmpty &&
                    (selectConceptsViewModel.selectedItems != null &&
                        selectConceptsViewModel.selectedItems!.isNotEmpty)) ...[
                  AtomicInputMaterialInfoView(
                      lesson: lesson,
                      connector: (AtomicInputMaterialViewModel infoModel) {
                        viewModel.initialMaterials.add(infoModel);
                      },
                      lessonType: type,
                      concepts: selectConceptsViewModel.selectedItems!,
                      learningStyle:
                          selectLearningStyleViewModel.selectedStyle),
                  TextButton(
                      onPressed: () async {
                        if (viewModel.validate()) {
                          bool result =
                              await viewModel.addMultipleMaterials(lesson);
                          if (result) {
                            showMessageDialog("Successfully uploaded", context);
                          } else {
                            showMessageDialog(
                                "There was an error uploading please try again",
                                context);
                          }
                        } else {
                          showMessageDialog("Please fill all fields", context);
                        }
                      },
                      child: const Text('Save'))
                ] else
                  const Text("Provide information above")
              ],
            ),
          ),
        );
      }),
    );
  }

  void showMessageDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
