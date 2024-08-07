import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Learner/Models/StudentDataModel.dart';
import 'package:team_adaptive/Module3_Learner/Services/StudentDataService.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import '../Services/StudentLessonService.dart';

class StudentLessonViewModel extends ChangeNotifier {
  StudentLessonService lessonService = StudentLessonService();
  StudentDataService dataService = StudentDataService();

  Future<List<LessonModel>> getCourseLessons(String courseID) async {
    var courseLessons = await lessonService.getLessonsByCourse(courseID);
    return courseLessons.where((element) => element.isSetupComplete!).toList();
  }

  Future<LessonMaterialModel?> getMainLesson(
      String courseID, String lessonID) async {
    try {
      StudentDataModel? studentData =
          await dataService.getStudentData(AuthServices().userInfo!.id!);
      List<LessonMaterialModel?> materials;
      studentData ??= await dataService.createStudentData(
          StudentDataModel.basic(AuthServices().userInfo!.id!));
      if (studentData!.currentLessons != null &&
          studentData.currentLessons![lessonID] != null) {
        return await lessonService.getLessonMaterialByTypeAndID(
            courseID: courseID,
            lessonID: lessonID,
            type: "main",
            materialID: studentData.currentLessons![lessonID]!);
      }
      materials = await lessonService.getLessonMaterialsByTypeAndStyle(
          courseID, lessonID, "main", studentData.currentLearningStyle!);
      materials.shuffle();
      studentData.currentLessons ??= {};
      studentData.currentLessons![lessonID] = materials[0]!.id!;
      await dataService.editStudentData(studentData);
      return materials[0];
    } on Exception catch (e) {
      print("Error getting main lesson in viewmodel: $e");
    }
  }

  Future<bool> completeMainLesson(String lessonID) async {
    try {
      StudentDataModel? studentData =
          await dataService.getStudentData(AuthServices().userInfo!.id!);
      studentData ??= await dataService.createStudentData(
          StudentDataModel.basic(AuthServices().userInfo!.id!));
      studentData!.currentLessons!.remove(lessonID);
      dataService.editStudentData(studentData);
      return true;
    } on Exception catch (e) {
      print("Error completing main lesson in viewmodel: $e");
    }
    return false;
  }
}
