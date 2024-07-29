import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherQuestionService.dart';

class TeacherQuestionViewModel extends ChangeNotifier {
  TeacherQuestionService teacherService = TeacherQuestionService();
  AuthServices authService = AuthServices();
  String? lessonID;

  //question retrieval
  List<QuestionModel> myQuestionPool = [];
  List<QuestionModel> otherQuestionPool = [];

  Future<void> initializeViewModel(String lessonID) async {
    if (this.lessonID == null || this.lessonID != lessonID) {
      List<QuestionModel>? allQuestions =
          await teacherService.getLessonQuestions(lessonID);
      this.lessonID = lessonID;
      String userID = authService.userInfo!.id!;
      myQuestionPool = [];
      otherQuestionPool = [];
      for (QuestionModel question in allQuestions!) {
        if (question.authorID == userID) {
          myQuestionPool.add(question);
        } else {
          otherQuestionPool.add(question);
        }
      }
      notifyListeners();
    }
  }

  Future<bool> addQuestion(QuestionModel question) async {
    if (await teacherService.addQuestion(question, lessonID!)) {
      myQuestionPool.add(question);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> editQuestion(QuestionModel question) async {
    if (await teacherService.editQuestion(question, lessonID!)) {
      notifyListeners();
      return true;
    }
    return false;

  }

  Future<bool> deleteQuestion(QuestionModel question) async {
    if (await teacherService.deleteQuestion(question, lessonID!)) {
      myQuestionPool.remove(question);
      notifyListeners();
      return true;
    }
    return false;
  }
}
