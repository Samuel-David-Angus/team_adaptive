import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Models/FeedbackModel.dart';

var color = Colors.grey[400];

class FeedbackView extends StatelessWidget {
  final FeedbackModel feedback;
  const FeedbackView({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    Map<String, double> conceptsAndFailureRates =
        feedback.lessonConceptFailureRates;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text('Score: ${feedback.learnerScore}',
              style: const TextStyle(fontSize: 24.0)),
          const SizedBox(height: 15),
          Text('Learner Skill level: ${feedback.skillLevel}',
              style: const TextStyle(fontSize: 24.0)),
          const SizedBox(height: 15),
          Text('Category: ${feedback.categorizedSkillLevel}',
              style: const TextStyle(fontSize: 24.0)),
          const SizedBox(height: 15),
          Text('Suggested Learning Style: ${feedback.diagnosedLearningStyle}',
              style: const TextStyle(fontSize: 24.0)),
          const SizedBox(height: 15),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    child:
                        const Text("Concept", style: TextStyle(fontSize: 24.0)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text("Failure Rate",
                        style: TextStyle(fontSize: 24.0)),
                  ),
                ],
              ),
              ...conceptsAndFailureRates.entries.map<TableRow>(
                (entry) {
                  return TableRow(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: color,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(entry.key,
                            style: const TextStyle(fontSize: 20.0)),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: color,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200, // specify the width you want
                              child: LinearProgressIndicator(
                                minHeight: 20,
                                value: entry.value / 100,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    10), // Optional: Add spacing between the progress bar and text
                            Text("${entry.value.toStringAsFixed(2)}%",
                                style: const TextStyle(fontSize: 20.0)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text('Weak Concepts:', style: TextStyle(fontSize: 24.0)),
          const SizedBox(height: 15),
          ...feedback.weakConcepts.map(
            (concept) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text(concept),
                  onPressed: () {
                    String lO = Uri.encodeFull(concept);
                    context.go('/materials/learning-outcome/$lO',
                        extra: concept);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
