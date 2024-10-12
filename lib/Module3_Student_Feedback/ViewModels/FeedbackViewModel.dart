import 'dart:math';

import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/AIService.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/FeedbackService.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

class FeedbackViewModel extends ChangeNotifier {
  late FeedbackModel feedback;
  TeacherLessonService lessonService = TeacherLessonService();
  FeedbackService feedbackService = FeedbackService();
  AuthServices authServices = AuthServices();
  AIServices aiService = AIServices();

  Future<String?> createFeedback(AssessmentModel assessment) async {
    try {
      feedback = FeedbackModel.createFromAssessment(
          assessment: assessment, userID: authServices.userInfo!.id!);
      feedback.feedbackTitle = "${assessment.lesson.lessonTitle!} Feedback";
      feedback.diagnosedLearningStyle =
          await determineLearningStyle("random args");
      AuthServices().userInfo!.learningStyle = feedback.diagnosedLearningStyle;
      bool sucessfullyUpdateLearningStyle =
          await feedbackService.updateUserLearningStyle(
              authServices.userInfo!.id!, feedback.diagnosedLearningStyle);
      if (!sucessfullyUpdateLearningStyle) {
        return null;
      }
      String? feedbackID = await feedbackService.addFeedback(feedback);
      return feedbackID;
    } on Exception catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  Future<String> determineLearningStyle(argsForPrompt) async {
    //PLS REPLACE WITH ACTUAL CALL TO AI SERVICE
    List<String> styles = ["Visual", "Text", "Audio"];
    await Future.delayed(const Duration(seconds: 1));
    return styles[Random().nextInt(3)];
  }

  Map<String, double> getConceptFailureRates() {
    return feedback.lessonConceptFailureRates;
  }

  Future<List<FeedbackModel>?> getUserFeedbacks() async {
    if (authServices.userInfo != null) {
      return await feedbackService
          .getFeedbackByLearnerID(authServices.userInfo!.id!);
    }
    return null;
  }
}
