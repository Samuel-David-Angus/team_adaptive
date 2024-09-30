import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/CreateEditQuestionViewModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherAddQuestionView extends StatelessWidget {
  final LessonModel lessonModel;
  final QuestionModel? question;
  final Future<ConceptMapModel?> conceptMap;
  late bool isEditing;
  bool isInitialized = false;
  late Future<bool> Function(QuestionModel) submit;

  TeacherAddQuestionView({super.key, this.question, required this.lessonModel})
      : conceptMap = ConceptMapService().getConceptMap(lessonModel.courseID!),
        isEditing = question != null;

  @override
  Widget build(BuildContext context) {
    final CreateEditQuestionViewModel addEditViewModel =
        Provider.of<CreateEditQuestionViewModel>(context);
    final TeacherQuestionViewModel teacherQuestionViewModel =
        Provider.of<TeacherQuestionViewModel>(context);
    if (!isInitialized) {
      isInitialized = true;
      !isEditing
          ? addEditViewModel.initializeCreate()
          : addEditViewModel.initializeEdit(question!);
      submit = isEditing
          ? (QuestionModel question) async {
              return await teacherQuestionViewModel.editQuestion(question);
            }
          : (QuestionModel question) async {
              return await teacherQuestionViewModel.addQuestion(question);
            };
    }
    return FutureBuilder<ConceptMapModel?>(
      future: conceptMap,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      Text(
                        isEditing ? 'Edit Question' : 'Add Question',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: TextFormField(
                    controller: addEditViewModel.questionController,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Write Question Here',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        selectConcept(lessonModel.learningOutcomes!, context);
                      },
                      child: const Text('Choose Concept'),
                    ),
                    const SizedBox(width: 10),
                    Text(addEditViewModel.concept != null
                        ? addEditViewModel.concept!
                        : "no concept chosen"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          controller: addEditViewModel.choiceController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Write Choice Here',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (addEditViewModel.validateChoice()) {
                          addEditViewModel.addChoice();
                          showMessageDialog(context, "Choice added");
                        } else {
                          showMessageDialog(
                              context, "Choice field must not be empty");
                        }
                      },
                      child: const Text('Add Choice'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choices:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: addEditViewModel.choiceList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(addEditViewModel.choiceList[index].text),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                addEditViewModel.deleteChoice(index);
                              },
                            ),
                          ],
                        ),
                        value: index == addEditViewModel.indexOfCorrectAnswer,
                        onChanged: (bool? value) {
                          if (value == true) {
                            addEditViewModel.setCorrectAnswer(index);
                          }
                        },
                      );
                    },
                  ),
                ),
                Center(
                    child: SizedBox(
                        width: 150.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (context.mounted) {
                              if (addEditViewModel.validateBeforeSubmitting()) {
                                String userID = teacherQuestionViewModel
                                    .authService.userInfo!.id!;
                                ConceptMapModel conceptMapModel =
                                    snapshot.data!;
                                QuestionModel createdQuestion =
                                    addEditViewModel.createQuestionModel(
                                        userID, conceptMapModel);
                                debugPrint("$createdQuestion");
                                bool result = await submit(createdQuestion);
                                debugPrint('finish');
                                if (result) {
                                  showMessageDialog(
                                      context, "Successfully added question");
                                } else {
                                  showMessageDialog(
                                      context, "Failed to add question");
                                }
                              } else {
                                showMessageDialog(context, "stuff missing");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.darkgreyTheme,
                          ),
                          child: Text(
                            isEditing ? 'Edit' : 'Add',
                            style: const TextStyle(
                              color: ThemeColor.offwhiteTheme,
                            ),
                          ),
                        )))
              ],
            ),
          );
        } else {
          return const Center(child: Text('Retrieved Concept Map is null'));
        }
      },
    );
  }
}

void showMessageDialog(BuildContext context, String message) {
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void selectConcept(List<String> concepts, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CreateEditQuestionViewModel>(
            builder: (context, viewModel, child) {
          String? prevConceptValue = viewModel.concept;
          return AlertDialog(
            title: const Text('Select Concept'),
            content: SingleChildScrollView(
              child: ListBody(
                children: concepts.map((item) {
                  return CheckboxListTile(
                    title: Text(item),
                    value:
                        viewModel.concept != null && item == viewModel.concept,
                    onChanged: (bool? checked) {
                      if (checked == true) {
                        viewModel.setConcept(item);
                      } else {
                        viewModel.setConcept(null);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  viewModel.setConcept(prevConceptValue);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      });
}
