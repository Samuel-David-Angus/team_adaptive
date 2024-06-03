import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherAssessmentService.dart';

class TeacherAssessmentViewModel extends ChangeNotifier {
  TeacherAssessmentService service = AssessmentService();
  AssessmentModel? map;

  Future<List<Question>> getQuestions(String)

   Future<bool> saveEdits() async {
    try {
      return await service.editConceptMap(map!);
    } catch (e) {
      print("Error saving map: $e");
    }
    return false;
  }
}