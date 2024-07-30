import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';

import '../Models/FeedbackModel.dart';

class FeedbackView extends StatelessWidget {
  final AssessmentModel assessment;
  late Future<bool> successfulFeedbackGenerated;
  bool justInitialized = true;
  FeedbackView({super.key, required this.assessment});


  @override
  Widget build(BuildContext context) {
    final FeedbackViewModel viewModel = Provider.of<FeedbackViewModel>(context);
    if (justInitialized) {
      justInitialized = false;
      successfulFeedbackGenerated = viewModel.createFeedback(assessment);
    }
    return TemplateView(highlighted: SELECTED.NONE, topRight: userInfo(context), child: FutureBuilder(
        future: successfulFeedbackGenerated,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occurred: ${snapshot.error}'),);
          } else
          if (snapshot.hasData && snapshot.data != null && snapshot.data!) {
            Map<String, double> conceptsAndFailureRates = viewModel.feedback
                .calculateLessonConceptFailureRates();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Feedback'),
                Text('Score: ${viewModel.feedback.getScore()}'),
                Text('Learner Skill level: ${assessment.calculateSkillLevel()}'),
                Text('Category: ${assessment.categorizeSkillLevel(assessment.calculateSkillLevel())}'),
                Table(
                  border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: 1,
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                  ),
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Concept"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Failure Rate"),
                        )
                      ]
                    ),
                    ...conceptsAndFailureRates.entries.map<TableRow>(
                            (entry) {
                          return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(entry.key),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200, // specify the width you want
                                        child: LinearProgressIndicator(
                                          value: entry.value / 100,
                                        ),
                                      ),
                                      const SizedBox(width: 10), // Optional: Add spacing between the progress bar and text
                                      Text((entry.value / 100).toStringAsFixed(2))
                                    ],
                                  ),
                                )
                              ]
                          );
                        }
                    ),
                  ]
                )
              ],
            );
          } else {
            return const Center(child: Text('Unable to load feedback'));
          }
        }));
  }
}
