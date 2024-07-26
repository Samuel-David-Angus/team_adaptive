
import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherQuestionService.dart';

class TeacherQuestionViewModel extends ChangeNotifier {
  TeacherQuestionService service = TeacherQuestionService();
  List<QuestionModel>? questionPool;

  void initializeViewModel(String lessonID) async {
    questionPool = await service.getLessonQuestions(lessonID);
  }

  Future<bool> addQuestions(List<QuestionModel> questions, String lessonID) async{
    return await service.addQuestions(questions, lessonID);
  }

  Future<bool> editQuestion(QuestionModel question, String lessonID) async {
    return await service.editQuestion(question, lessonID);
  }

}