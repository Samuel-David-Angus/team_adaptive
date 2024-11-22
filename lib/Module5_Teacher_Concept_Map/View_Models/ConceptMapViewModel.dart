import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';

import '../Models/ConceptMapModel.dart';

class ConceptMapViewModel extends ChangeNotifier {
  ConceptMapService service = ConceptMapService();
  ConceptMapModel? map;
  Map<String, String>? lessonNameMap;

  void createConceptMap() {
    map = ConceptMapModel.setAll(
        id: null,
        courseID: null,
        conceptMap: {},
        lessonPartitions: {},
        maxFailureRates: {});
  }

  Future<bool> uploadConceptMap(String courseID) async {
    return await service.uploadConceptMap(courseID, map!);
  }

  bool addLocalLearningOutcome(
      String concept, double maxFailureRate, String lessonID) {
    try {
      notifyListeners();
      return map!.addLocalLearningOutcome(concept, maxFailureRate, lessonID);
    } catch (e) {
      debugPrint('Concept map is not available.');
    }
    return false;
  }

  bool deleteConcept(String concept, String lessonID) {
    try {
      notifyListeners();
      return map!.removeConcept(concept, lessonID);
    } catch (e) {
      debugPrint("Error deleting concept: $e");
    }
    return false;
  }

  Future<void> getConceptMap(String courseID) async {
    final results = await Future.wait([
      service.getConceptMap(courseID),
      getCourseLessonNameMap(courseID),
    ]);

    map = results[0] as ConceptMapModel?; // Adjust the type if needed
    lessonNameMap =
        results[1] as Map<String, String>; // Adjust the type if needed

    notifyListeners();
  }

  bool setPrerequisite(String concept, String prereq) {
    try {
      notifyListeners();
      return map!.setPrerequisite(concept, prereq);
    } catch (e) {
      debugPrint("Error setting prerequisite: $e");
    }
    return false;
  }

  Future<bool> saveEdits(String lessonID) async {
    try {
      return await service.editConceptMapAndAddNewLOs(map!, lessonID);
    } catch (e) {
      debugPrint("Error saving map: $e");
    }
    return false;
  }

  Future<List<LearningOutcomeModel>> getExternalLearningOutcomes(
      String lessonID) async {
    List<LearningOutcomeModel>? lOs =
        await service.getExternalLearningOutcomes(lessonID);
    if (lOs == null) {
      throw Exception("Error getting external learning outcomes");
    }
    return lOs!;
  }

  Future<List<LearningOutcomeModel>> getAllLearningOutcomes() async {
    List<LearningOutcomeModel>? lOs = await service.getAllLearningOutcomes();
    if (lOs == null) {
      throw Exception("Error getting external learning outcomes");
    }
    return lOs!;
  }

  Future<LearningOutcomeModel> getLearningOutcome(String lO) async {
    LearningOutcomeModel? learningOutcomeModel =
        await service.getLearningOutcome(lO);
    if (learningOutcomeModel == null) {
      throw Exception("Cant get lO");
    }
    return learningOutcomeModel;
  }

  Future<Map<String, String>> getCourseLessonNameMap(String courseID) async {
    List<LessonModel> courseLessons =
        await TeacherLessonService().getLessonsByCourse(courseID);
    Map<String, String> nameMap = {};
    for (var lesson in courseLessons) {
      nameMap[lesson.id!] = lesson.lessonTitle!;
    }
    return nameMap;
  }
}
