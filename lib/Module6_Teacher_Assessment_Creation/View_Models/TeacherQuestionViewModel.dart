import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherQuestionService.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/ViewModels/LessonDashboardViewModel.dart';

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
          debugPrint("$userID  ${question.authorID}");
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

  List<PieChartSectionData>? generateSectionsFromQuestion(
      QuestionModel question) {
    int totalCount = question.tally.values.reduce((a, b) => a + b) +
        question.unansweredCount;
    if (totalCount == 0) {
      return null;
    }

    List<Color> colors = generateColorSequence(question.tally.length);
    int index = 0;

    return [
      ...question.tally.entries.map((entry) {
        return PieChartSectionData(
            value: entry.value / totalCount, title: entry.key, radius: 60);
      }),
      PieChartSectionData(
          value: question.unansweredCount / totalCount,
          title: "Unanswered",
          radius: 60,
          color: colors[index++])
    ];
  }
}
