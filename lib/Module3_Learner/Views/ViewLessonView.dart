import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module3_Learner/Views/Iframe.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Views/AssessmentView.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class ViewLessonView extends StatelessWidget {
  LessonModel lesson;
  ViewLessonView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentLessonViewModel>(context, listen: false);
    return FutureBuilder<LessonMaterialModel?>(
        future: viewModel.getMainLesson(lesson.courseID!, lesson.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No lesson material found.'));
          } else {
            // When data is fetched successfully
            final lessonMaterial = snapshot.data!;

            return TemplateView(
                highlighted: SELECTED.NONE,
                topRight: userInfo(context),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDialog(context: context,
                                builder: (context) {
                                  return PointerInterceptor(
                                    child: AlertDialog(
                                      title: Text('Heads Up!'),
                                      content: Text('After completing you will be redirected to an assessment.'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel')
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              await viewModel.completeMainLesson(lesson.id!);
                                              Navigator.of(context).pop();
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AssessmentView(lessonModel: lesson)));
                                            },
                                            child: Text('Ok')
                                        )
                                      ],
                                    ),

                                  );
                                }
                            );


                          },
                          child: Text('Complete Lesson')
                      ),
                      Expanded(
                        child: IframeView(
                          source: lessonMaterial.src!,
                        ),
                      ),
                    ],
                  ),
                )
            );
          }
        }
    );
  }
}
