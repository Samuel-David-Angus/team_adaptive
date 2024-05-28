import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';

import '../Models/ConceptMapModel.dart';

class ConceptMapViewModel extends ChangeNotifier {
  ConceptMapService service = ConceptMapService();
  ConceptMapModel? map;

  bool addConcept(String concept){
    try {
      int? length = map?.conceptMap!.keys.length!;
      List<int> generatedList = List.generate(length! + 1, (index) => 0);
      map?.conceptMap?.putIfAbsent(concept, ()=>generatedList);
      map?.conceptMap = map?.conceptMap?.map((key, value) {
        List<int> extendedList = List<int>.from(value);
        while (extendedList.length < length + 1) {
          extendedList.add(0);  // Add zeroes to extend the list
        }
        return MapEntry(key, extendedList);
      });
      notifyListeners();
      return true;
    } catch (e) {
      print('Concept map is not available.');
    }
    return false;
  }
  bool deleteConcept(String concept){
    try {
      int? length = map?.conceptMap!.keys.length!;
      int conceptIndex = map!.conceptMap!.keys!.toList().indexOf(concept);
      map?.conceptMap!.remove(concept);
      map?.conceptMap = map?.conceptMap?.map((key, value) {
        List<int> shrunkList = List<int>.from(value);
        shrunkList.removeAt(conceptIndex);
        return MapEntry(key, shrunkList);
      });
      notifyListeners();
      return true;
    } catch (e) {
      print("Error deleting concept: $e");
    }
    return false;
  }
  getConceptMap(String courseID) async {
    map = await service.getConceptMap(courseID);

    notifyListeners();
  }
  bool setPrerequisite(String concept, String prereq) {
    try {
      int index = map!.conceptMap!.keys.toList().indexOf(prereq);
      if (index == -1) {
        return false;
      }
      int value = map!.conceptMap![concept]![index];
      if (value == 0) {
        map!.conceptMap![concept]![index] = 1;
      } else {
        map!.conceptMap![concept]![index] = 0;
      }
      notifyListeners();
      return true;
    } catch (e) {
      print("Error setting prerequisite: $e");
    }
    return false;
  }

   Future<bool> saveEdits() async {
    try {
      return await service.editConceptMap(map!);
    } catch (e) {
      print("Error saving map: $e");
    }
    return false;
  }
}