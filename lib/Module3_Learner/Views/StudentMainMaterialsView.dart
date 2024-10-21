import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class StudentMainMaterialsView extends StatelessWidget {
  final LessonModel lesson;
  Future<Map<String, List<LessonMaterialModel>>?>? materialsWithLearningStyles;
  final String learnerLearningStyle = AuthServices().userInfo!.learningStyle!;
  StudentMainMaterialsView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    StudentLessonViewModel viewModel =
        Provider.of<StudentLessonViewModel>(context, listen: false);
    materialsWithLearningStyles ??= viewModel
        .getMainLessonsMaterialsWithLearningStyle(lesson.courseID!, lesson.id!);
    return FutureBuilder<Map<String, List<LessonMaterialModel>>?>(
        future: materialsWithLearningStyles,
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
                                    '/courses/${lesson.courseID}/lessons/${lesson.id}/main/${material.id!}',
                                    extra: (
                                      lesson: lesson,
                                      material: material
                                    ));
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
