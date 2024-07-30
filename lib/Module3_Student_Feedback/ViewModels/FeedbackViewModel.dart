
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/AIService.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

class FeedbackViewModel extends ChangeNotifier{
  late FeedbackModel feedback;
  TeacherLessonService lessonService = TeacherLessonService();
  AIServices aiService = AIServices();

  Future<bool> createFeedback(AssessmentModel assessment) async {
    try {
      feedback = FeedbackModel.setAll(assessment: assessment, userID: AuthServices().userInfo!.id!);
      feedback.diagnosedLearningStyle = await determineLearningStyle("random args");
      feedback.suggestedLessons = await getSuggestedMaterials();
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> determineLearningStyle(argsForPrompt) async {
    //PLS REPLACE WITH ACTUAL CALL TO AI SERVICE
    List<String> styles = ["Visual", "Text", "Audio"];
    await Future.delayed(const Duration(seconds: 1));
    return styles[Random().nextInt(3)];
  }

  LessonMaterialModel getRandomMaterialByConceptAndLearningStyle(List<LessonMaterialModel> pool, String concept, String learningStyle) {
    final filteredList = pool.where((item) => item.concepts!.contains(concept) && item.learningStyle == learningStyle).toList();
    return filteredList[Random().nextInt(filteredList.length)];
  }

  Future<List<Map<String, dynamic>>> getSuggestedMaterials() async {
    List<LessonMaterialModel> allMainLessons = await lessonService.getLessonMaterialsByType(feedback.assessment.lesson.courseID!, feedback.assessment.lesson.id!, "main");
    List<LessonMaterialModel> allSubLessons = await lessonService.getLessonMaterialsByType(feedback.assessment.lesson.courseID!, feedback.assessment.lesson.id!, "sub");
    if (allMainLessons.isEmpty || allSubLessons.isEmpty) {
      throw Exception('failed getting lessons');
    }
    List<Map<String, dynamic>> result = [];
    feedback.calculateWeakConceptsAndTheirPrereqs().forEach(
        (String mainConcept, List<String> prereqs) {
          Map<String, dynamic> item = {};
          item["main"] = {"concept": mainConcept, "lesson": getRandomMaterialByConceptAndLearningStyle(allMainLessons, mainConcept, feedback.diagnosedLearningStyle)};
          item["prereqs"] = List<Map<String, dynamic>>.generate(
              prereqs.length,
              (index) {
                return {"concept": prereqs[index], "lesson": getRandomMaterialByConceptAndLearningStyle(allSubLessons, prereqs[index], feedback.diagnosedLearningStyle)};
              }
          );
          result.add(item);
        }
    );
    return result;
  }

  Map<String, double> getConceptFailureRates() {
    return feedback.calculateLessonConceptFailureRates();
  }
}