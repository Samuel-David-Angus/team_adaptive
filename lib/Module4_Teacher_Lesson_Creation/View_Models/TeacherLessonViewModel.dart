import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

import '../Models/LessonMaterialModel.dart';

class TeacherLessonViewModel extends ChangeNotifier {
  TeacherLessonService service = TeacherLessonService();
  bool canAddMoreLessons = true;
  late Future<List<LessonModel>> allLessons;

  String getLessonID(String courseID) {
    return service.getLessonID(courseID);
  }

  Future<bool> addLesson(String title, String description, String courseId,
      List<String> learningOutcomes,
      {String? lessonID}) async {
    LessonModel lesson = LessonModel();
    if (lessonID != null) {
      lesson.id = lessonID;
    }
    lesson.lessonTitle = title;
    lesson.lessonDescription = description;
    lesson.courseID = courseId;
    lesson.learningOutcomes = learningOutcomes;
    lesson.isSetupComplete = false;
    notifyListeners();
    return await service.addLesson(lesson);
  }

  void refresh() {
    notifyListeners();
  }

  Future<List<LessonModel>> getLessonByCourse(String courseID) async {
    canAddMoreLessons = true;
    List<LessonModel> lessons = await service.getLessonsByCourse(courseID);
    for (var lesson in lessons) {
      if (!lesson.isSetupComplete!) {
        canAddMoreLessons = false;
        break;
      }
    }
    return lessons;
  }

  Future<List<LessonMaterialModel>> getLessonMaterialsByType(
      String courseID, String lessonID, String type) async {
    return await service.getLessonMaterialsByType(courseID, lessonID, type);
  }

  Future<bool> addLessonMaterial(
      String courseID,
      String lessonID,
      String title,
      String author,
      String src,
      String learningStyle,
      List<String> concepts,
      String type) async {
    LessonMaterialModel lessonMaterial = LessonMaterialModel();
    lessonMaterial.courseID = courseID;
    lessonMaterial.title = title;
    lessonMaterial.lessonID = lessonID;
    lessonMaterial.author = author;
    lessonMaterial.src = src;
    lessonMaterial.learningStyle = learningStyle;
    lessonMaterial.concepts = concepts;
    lessonMaterial.type = type;
    notifyListeners();
    return await service.addLessonMaterial(courseID, lessonMaterial);
  }

  Future<bool> editLessonMaterial(
      String courseID, LessonMaterialModel lessonMaterial) async {
    return await service.editLessonMaterial(courseID, lessonMaterial);
  }

  Future<bool> deleteLessonMaterial(
      String courseID, LessonMaterialModel lessonMaterial) async {
    return await service.deleteLessonMaterial(courseID, lessonMaterial);
  }
}
