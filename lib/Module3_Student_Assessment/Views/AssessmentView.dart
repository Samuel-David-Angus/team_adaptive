import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Student_Assessment/ViewModels/AssessmentViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class AssessmentView extends StatelessWidget {
  final LessonModel lessonModel;
  bool justInitialized = false;
  int assessmentLength = 10;
  late Future<bool> successfulGeneratedAssessment;
  AssessmentView({super.key, required this.lessonModel});

  @override
  Widget build(BuildContext context) {
    final AssessmentViewModel viewModel = Provider.of<AssessmentViewModel>(context);
    if (!justInitialized) {
      justInitialized = true;
      successfulGeneratedAssessment = viewModel.createNewAssessment(lessonModel, assessmentLength);
    }
    return TemplateView(highlighted: SELECTED.NONE, topRight: userInfo(context),
        child: FutureBuilder<bool>(
          future: successfulGeneratedAssessment,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error occurred: ${snapshot.error}'),);
            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!) {
              return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Assessment'),
                        ...generateTestItems(viewModel),
                        ElevatedButton(
                            onPressed: () async {
                              bool? confirmSubmit = await showConfirmationDialog(context, "Are you sure you want to submit");
                              if (confirmSubmit == true) {
                                bool success = await viewModel.submitAssessment();
                                if (success) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackView(assessment: viewModel.assessmentModel,)));
                                } else {
                                  showConfirmationDialog(context, "Error submitting assessment");
                                }
                              }

                            },
                            child: const Text('Submit')
                        )
                      ],
                    ),
                  )
              );
            } else {
              return const Center(child: Text('Unable to load assessment'));
            }
          },

        )
    );
  }
}

List<Widget> generateTestItems(AssessmentViewModel viewModel) {
  List<Map<String, dynamic>> questionAndChoices = viewModel.questionAndChoices;
  return List.generate(questionAndChoices.length,
      (index1) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(questionAndChoices[index1]["question"]),
                const SizedBox(height: 20,),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: questionAndChoices[index1]["choices"].length,
                  itemBuilder: (context, index2) {
                    return CheckboxListTile(

                      title: Text(questionAndChoices[index1]["choices"][index2]),
                      value: index2 == viewModel.learnerAnswers[index1],
                      onChanged: (bool? value) {
                        if (value == true) {
                          viewModel.setAnswer(index1, index2);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        );
      }
  );
}

Future<bool?> showConfirmationDialog(BuildContext context, String message) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Message'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
