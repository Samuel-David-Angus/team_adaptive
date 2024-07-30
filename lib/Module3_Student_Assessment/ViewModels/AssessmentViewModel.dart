import 'dart:math';

import 'package:flutter/material.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherQuestionService.dart';

import '../../Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';

class AssessmentViewModel extends ChangeNotifier {
  TeacherQuestionService questionService = TeacherQuestionService();
  late AssessmentModel assessmentModel;
  late List<Map<String, dynamic>> questionAndChoices;
  late List<int> learnerAnswers;
  late LessonModel lesson;


  Future<bool> createNewAssessment(LessonModel lesson, int length) async {
    List<QuestionModel>? questions = await questionService.getLessonQuestions(lesson.id!);
    ConceptMapModel? conceptMapModel = await ConceptMapService().getConceptMap(lesson.courseID!);
    if (questions != null && conceptMapModel != null) {
      questions.shuffle();
      questions = questions.sublist(0, min(length, questions.length));
      this.lesson = lesson;
      assessmentModel = AssessmentModel.createNew(lessonID: lesson, questions: questions, conceptMapModel: conceptMapModel);
      questionAndChoices = assessmentModel.processedQuestions;
      learnerAnswers = List.filled(questionAndChoices.length, -1);
      return true;
    }


    return false;
  }

  void setAnswer(int questionIndex, int answer) {
    learnerAnswers[questionIndex] = answer;
    notifyListeners();
  }

  bool checkSelectedAnswer(int questionIndex, int selectedIndex) {
    return learnerAnswers[questionIndex] == selectedIndex;
  }

  Future<bool> submitAssessment() async {
    assessmentModel.processAssessment(learnerAnswers);
    List<QuestionModel> adjustedCopies = assessmentModel.getCopyOfQuestionsWithAdjustedDifficulties();
    bool res = await questionService.updateQuestionsFromAssessment(adjustedCopies, lesson.id!);
    return res;
  }

}