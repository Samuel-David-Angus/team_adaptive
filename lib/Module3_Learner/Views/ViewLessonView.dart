import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:team_adaptive/Module3_Learner/Views/Iframe.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class ViewLessonView extends StatelessWidget {
  final LessonModel lesson;
  final LessonMaterialModel mainLessonMaterial;
  const ViewLessonView(
      {super.key, required this.lesson, required this.mainLessonMaterial});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return PointerInterceptor(
                        child: AlertDialog(
                          title: const Text('Heads Up!'),
                          content: const Text(
                              'After completing you will be redirected to an assessment.'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  GoRouter.of(context).go(
                                      '/courses/${lesson.courseID}/lessons/${lesson.id}/assessment',
                                      extra: lesson);
                                },
                                child: const Text('Ok'))
                          ],
                        ),
                      );
                    });
              },
              child: const Text('Complete Lesson')),
          Expanded(
            child: IframeView(
              source: mainLessonMaterial.src!,
            ),
          ),
        ],
      ),
    );
  }
}
