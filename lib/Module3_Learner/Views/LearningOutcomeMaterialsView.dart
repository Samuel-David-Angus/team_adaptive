import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';

class LearningOutcomeMaterialsView extends StatefulWidget {
  final String learningOutcome;
  const LearningOutcomeMaterialsView({
    super.key,
    required this.learningOutcome,
  });

  @override
  State<LearningOutcomeMaterialsView> createState() =>
      _LearningOutcomeMaterialsViewState();
}

class _LearningOutcomeMaterialsViewState
    extends State<LearningOutcomeMaterialsView> {
  String? learnerLearningStyle;
  Future<Map<String, List<LessonMaterialModel>>>? materialsWithLearningStyle;

  @override
  Widget build(BuildContext context) {
    learnerLearningStyle ??=
        Provider.of<AuthServices>(context).userInfo?.learningStyle;
    if (learnerLearningStyle == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    materialsWithLearningStyle ??=
        Provider.of<StudentLessonViewModel>(context, listen: false)
            .getLOMaterials(widget.learningOutcome);
    return FutureBuilder<Map<String, List<LessonMaterialModel>>>(
        future: materialsWithLearningStyle!,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No data available')); // No data state
          } else {
            var map = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future<LearningOutcomeModel> model =
                                  Provider.of<ConceptMapViewModel>(context)
                                      .getLearningOutcome(
                                          widget.learningOutcome);
                              return AlertDialog(
                                content: FutureBuilder<LearningOutcomeModel>(
                                    future: model,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // While the connection is still waiting, show a loading indicator
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        // If there was an error fetching the data, show an error message
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else if (snapshot.hasData) {
                                        // If data is successfully fetched, display the LearningOutcomeModel
                                        LearningOutcomeModel learningOutcome =
                                            snapshot.data!;
                                        return Center(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            child: ListView.builder(
                                                itemCount: learningOutcome
                                                    .directPrereqs.length,
                                                itemBuilder: (context, index) {
                                                  String prereq =
                                                      learningOutcome
                                                          .directPrereqs[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        String prereqPath =
                                                            Uri.encodeFull(
                                                                prereq);
                                                        Navigator.of(context)
                                                            .pop();
                                                        GoRouter.of(context).go(
                                                            '/materials/learning-outcome/$prereqPath',
                                                            extra: prereq);
                                                      },
                                                      child: Text(prereq),
                                                    ),
                                                  );
                                                }),
                                          ), // Example field
                                        );
                                      } else {
                                        // If none of the above conditions are met, return a fallback widget
                                        return const Center(
                                            child: Text('No data available.'));
                                      }
                                    }),
                              );
                            });
                      },
                      child: const Text('Prerequisites')),
                  ...map.entries.map<Widget>(
                    (MapEntry<String, List<LessonMaterialModel>> entry) {
                      return Column(
                        children: [
                          Text(entry.key +
                              (entry.key == learnerLearningStyle
                                  ? " (Recommended)"
                                  : "")),
                          ...entry.value.map((LessonMaterialModel material) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  context.go(
                                      '/courses/${material.courseID!}/lessons/${material.lessonID!}/sub/${material.id!}',
                                      extra: material);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    material.title!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const Divider(),
                        ],
                      );
                    },
                  ).toList()
                ],
              ),
            );
          }
        });
  }
}
