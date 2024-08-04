import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

import '../Models/LessonMaterialModel.dart';

class TeacherLessonViewModel extends ChangeNotifier {
  TeacherLessonService service = TeacherLessonService();

  Future<bool> addLesson(String title, String description, String courseId,
      List<String> concepts) async {
    LessonModel lesson = LessonModel();
    lesson.lessonTitle = title;
    lesson.lessonDescription = description;
    lesson.courseID = courseId;
    lesson.concepts = concepts;
    notifyListeners();
    return await service.addLesson(lesson);
  }

  Future<List<LessonModel>> getLessonByCourse(String courseID) async {
    return await service.getLessonsByCourse(courseID);
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

  Future<bool> addMultipleMaterials(
      LessonModel lesson, List<LessonMaterialModel> materials) {
    return service.addMultipleLessonMaterials(
        lesson.courseID!, lesson.id!, materials);
  }
}
