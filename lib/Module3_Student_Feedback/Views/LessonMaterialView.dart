import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Learner/Views/Iframe.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

class LessonMaterialView extends StatelessWidget {
  final LessonMaterialModel lessonMaterial;
  const LessonMaterialView({super.key, required this.lessonMaterial});

  @override
  Widget build(BuildContext context) {
    return TemplateView(
      highlighted: SELECTED.NONE,
      topRight: userInfo(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: IframeView(source: lessonMaterial.src!,),
        )
      ),
    );
  }
}
