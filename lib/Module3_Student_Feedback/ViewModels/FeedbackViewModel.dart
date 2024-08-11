
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/AIService.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/FeedbackService.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

class FeedbackViewModel extends ChangeNotifier{
  late FeedbackModel feedback;
  TeacherLessonService lessonService = TeacherLessonService();
  FeedbackService feedbackService = FeedbackService();
  AuthServices authServices = AuthServices();
  AIServices aiService = AIServices();

  Future<bool> createFeedback(AssessmentModel assessment) async {
    try {
      feedback = FeedbackModel.createFromAssessment(assessment: assessment, userID: authServices.userInfo!.id!);
      feedback.feedbackTitle = "${assessment.lesson.lessonTitle!} Feedback";
      feedback.diagnosedLearningStyle = await determineLearningStyle("random args");
      AuthServices().userInfo!.learningStyle = feedback.diagnosedLearningStyle;
      var res = await Future.wait([
        feedbackService.updateUserLearningStyle(authServices.userInfo!.id!, feedback.diagnosedLearningStyle),
        getSuggestedMaterials()
      ]);
      feedback.suggestedLessons = res[1] as List<Map<String, dynamic>>;
      await feedbackService.addFeedbackAndLessons(feedback);
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> retrieveFeedbackMaterials(FeedbackModel feedbackHalf) async {
    feedback = feedbackHalf;
    List<LessonMaterialModel>? materials = await feedbackService.getFeedbackMaterials(feedback.id, feedback.lessonID);
    if (materials == null) {
      throw Exception('Error getting materials');
    }
    feedback.setRetrievedMaterials(materials);
    return true;
  }

  Future<String> determineLearningStyle(argsForPrompt) async {
    //PLS REPLACE WITH ACTUAL CALL TO AI SERVICE
    List<String> styles = ["Visual", "Text", "Audio"];
    await Future.delayed(const Duration(seconds: 1));
    return styles[Random().nextInt(3)];
  }

  LessonMaterialModel? getRandomMaterialByConceptAndLearningStyle(List<LessonMaterialModel> pool, String concept, String learningStyle) {
    final filteredList = pool.where((item) => item.concepts!.contains(concept) && item.learningStyle == learningStyle).toList();
    if (filteredList.isEmpty) {
      return null;
    }
    return filteredList[Random().nextInt(filteredList.length)];
  }

  Future<List<Map<String, dynamic>>> getSuggestedMaterials() async {
    List<LessonMaterialModel> allMainLessons = await lessonService.getLessonMaterialsByType(feedback.courseID, feedback.lessonID, "main");
    List<LessonMaterialModel> allSubLessons = await lessonService.getLessonMaterialsByType(feedback.courseID, feedback.lessonID, "sub");
    // if (allMainLessons.isEmpty || allSubLessons.isEmpty) {
    //   throw Exception('failed getting lessons');
    // }
    List<Map<String, dynamic>> result = [];
    feedback.weakConceptsAndTheirPrereqs.forEach(
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
    return feedback.lessonConceptFailureRates;
  }

  Future<List<FeedbackModel>?> getUserFeedbacks() async {
    return await feedbackService.getFeedbackByLearnerID(authServices.userInfo!.id!);
  }
}