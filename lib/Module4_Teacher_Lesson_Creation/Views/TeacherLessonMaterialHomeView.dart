import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonMaterialListView.dart';

class TeacherLessonMaterialHomeView extends StatelessWidget {
  LessonModel lesson;
  TeacherLessonMaterialHomeView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TabBar(
                      tabs: [
                        Tab(
                          text: "Main Lessons",
                        ),
                        Tab(
                          text: "Sub Lessons",
                        )
                      ]
                  ),
                  Expanded(
                      child: TabBarView(
                          children: [
                            TeacherLessonMaterialListView(lesson: lesson, type: "main"),
                            TeacherLessonMaterialListView(lesson: lesson, type: "sub"),
                          ]
                      )
                  )
                ],
              ),
            )
        ));
  }
}
