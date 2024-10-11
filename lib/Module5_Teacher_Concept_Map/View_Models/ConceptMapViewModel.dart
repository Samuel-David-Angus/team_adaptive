import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';

import '../Models/ConceptMapModel.dart';

class ConceptMapViewModel extends ChangeNotifier {
  ConceptMapService service = ConceptMapService();
  ConceptMapModel? map;

  void createConceptMap() {
    map = ConceptMapModel.setAll(
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

  void getConceptMap(String courseID) async {
    map = await service.getConceptMap(courseID);
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

  Future<bool> saveEdits() async {
    try {
      return await service.editConceptMap(map!);
    } catch (e) {
      debugPrint("Error saving map: $e");
    }
    return false;
  }
}
