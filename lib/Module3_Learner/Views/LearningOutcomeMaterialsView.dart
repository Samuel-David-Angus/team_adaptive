import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

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
                children: map.entries.map<Widget>(
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
                ).toList(),
              ),
            );
          }
        });
  }
}
