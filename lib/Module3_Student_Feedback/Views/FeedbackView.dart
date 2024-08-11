import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/LessonMaterialView.dart';

import '../Models/FeedbackModel.dart';

var color = Colors.grey[400];

class FeedbackView extends StatelessWidget {
  final FeedbackModel? feedback;
  final AssessmentModel assessment;
  late Future<bool> successfulFeedbackGenerated;
  bool justInitialized = true;
  FeedbackView({super.key, required this.assessment, this.feedback});


  @override
  Widget build(BuildContext context) {
    final FeedbackViewModel viewModel = Provider.of<FeedbackViewModel>(context);
    if (justInitialized) {
      justInitialized = false;
      if (feedback == null) {
        successfulFeedbackGenerated = viewModel.createFeedback(assessment);
      } else {
        successfulFeedbackGenerated = viewModel.retrieveFeedbackMaterials(feedback!);
      }
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
                .lessonConceptFailureRates;
            return DefaultTabController(
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const TabBar(
                          tabs: [
                            Tab(text: 'Diagnostics'),
                            Tab(text: 'Recommended Lessons',)
                      ]),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15,),
                                  Text('Score: ${viewModel.feedback.learnerScore}', style: const TextStyle(fontSize: 24.0),),
                                  const SizedBox(height: 15,),
                                  Text('Learner Skill level: ${assessment.calculateSkillLevel()}', style: const TextStyle(fontSize: 24.0),),
                                  const SizedBox(height: 15,),
                                  Text('Category: ${assessment.categorizeSkillLevel(assessment.calculateSkillLevel())}', style: const TextStyle(fontSize: 24.0),),
                                  const SizedBox(height: 15,),
                                  Text('Suggested Learning Style: ${viewModel.feedback.diagnosedLearningStyle}', style: const TextStyle(fontSize: 24.0),),
                                  const SizedBox(height: 15,),
                                  Table(
                                      children: [
                                        TableRow(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                padding: const EdgeInsets.all(10.0),
                                                child: const Text("Concept", style: TextStyle(fontSize: 24.0),),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                padding: const EdgeInsets.all(10.0),
                                                child: const Text("Failure Rate", style: TextStyle(fontSize: 24.0),),
                                              )
                                            ]
                                        ),
                                        ...conceptsAndFailureRates.entries.map<TableRow>(
                                                (entry) {
                                              return TableRow(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                      color: color,
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text(entry.key, style: const TextStyle(fontSize: 20.0),),
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
                                                          const SizedBox(width: 10), // Optional: Add spacing between the progress bar and text
                                                          Text("${entry.value.toStringAsFixed(2)}%", style: const TextStyle(fontSize: 20.0),)
                                                        ],
                                                      ),
                                                    )
                                                  ]
                                              );
                                            }
                                        ),
                                      ]
                                  ),
                                  const SizedBox(height: 15,),
                                  const Text('Weak Concepts:', style: TextStyle(fontSize: 24.0)),
                                  const SizedBox(height: 15,),
                                  ...viewModel.feedback.findWeakConcepts().map(
                                          (concept) {
                                        return Padding(padding: const EdgeInsets.all(8.0), child: Text(concept),);
                                      }
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                  children: [
                                    ...viewModel.feedback.suggestedLessons.map(
                                        (item) {
                                          print(item);
                                          return Column(
                                            children: [
                                              Text("Main Lesson: ${item["main"]["concept"]}"),
                                              Card(
                                                  child: SizedBox(
                                                    width: 800,
                                                    child: ListTile(
                                                      title: Text(item["main"]["lesson"].title!),
                                                      trailing: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => LessonMaterialView(lessonMaterial: item["main"]["lesson"])));
                                                            },
                                                            child: const Text('View'),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              const Text("Prerequisites:"),
                                              ...item["prereqs"].map(
                                                  (item2) {
                                                    return Row(
                                                      children: [
                                                        Text(item2["concept"]),
                                                        Card(
                        
                                                            child: SizedBox(
                                                              width: 800,
                                                              child: ListTile(
                                                                title: Text(item2["lesson"].title!),
                                                                trailing: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LessonMaterialView(lessonMaterial: item2["lesson"])));
                                                                      },
                                                                      child: const Text('View'),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    );
                                                  }
                                              )
                                            ],
                                          );
                                        }
                                    )
                                  ]
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            );
          } else {
            return const Center(child: Text('Unable to load feedback'));
          }
        }));
  }
}

