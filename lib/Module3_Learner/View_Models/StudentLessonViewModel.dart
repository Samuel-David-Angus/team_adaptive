import 'package:flutter/material.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import '../Services/StudentLessonService.dart';

class StudentLessonViewModel extends ChangeNotifier {
  StudentLessonService lessonService = StudentLessonService();

  Future<List<LessonModel>> getCourseLessons(String courseID) async {
    var courseLessons = await lessonService.getLessonsByCourse(courseID);
    return courseLessons.where((element) => element.isSetupComplete!).toList();
  }

  Future<Map<String, List<LessonMaterialModel>>?>
      getMainLessonsMaterialsWithLearningStyle(
          String courseID, String lessonID) async {
    try {
      List<LessonMaterialModel> materials = await lessonService
          .getLessonMaterialsByType(courseID, lessonID, "main");
      Map<String, List<LessonMaterialModel>> learningStyleWithMaterials = {
        "Text": [],
        "Audio": [],
        "Visual": []
      };
      for (var material in materials) {
        learningStyleWithMaterials[material.learningStyle!]!.add(material);
      }
      return learningStyleWithMaterials;
    } on Exception catch (e) {
      debugPrint("Error getting main lesson in viewmodel: $e");
    }
    return null;
  }

  Future<Map<String, List<LessonMaterialModel>>> getLOMaterials(
      String lO) async {
    print(lO);
    List<LessonMaterialModel>? allMaterials =
        await lessonService.findSubMaterialsByLO(lO);
    Map<String, List<LessonMaterialModel>> learningStyleWithMaterials = {
      "Text": [],
      "Audio": [],
      "Visual": []
    };
    for (LessonMaterialModel material in allMaterials!) {
      learningStyleWithMaterials[material.learningStyle!]!.add(material);
    }
    return learningStyleWithMaterials;
  }
}
