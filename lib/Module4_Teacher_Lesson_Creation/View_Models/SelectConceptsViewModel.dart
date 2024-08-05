import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel_old.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';

class SelectConceptsViewModel extends ChangeNotifier {
  List<String>? items;
  List<String>? selectedItems;
  List<String>? prevSelectedItems;

  Future<void> loadDataToAdd({String? courseID, LessonModel? lesson}) async {
    try {
      assert(courseID != null || lesson != null);
      ConceptMapModel? conceptMapModel = await ConceptMapService()
          .getConceptMap(courseID ?? lesson!.courseID!);
      List<String> keys = conceptMapModel!.conceptMap!.keys.toList();
      Map<String, List<int>> map = conceptMapModel.conceptMap!;
      selectedItems = [];
      if (lesson == null) {
        items = keys;
      } else {
        items = [];
        for (var concept in lesson.concepts!) {
          items!.add("$concept(main)");
          int indexOfConcept = conceptMapModel.indexOfConcept(concept);
          List<int> val = map[concept]!;
          for (int i = 0; i < val.length; i++) {
            if (val[i] == 1 && i != indexOfConcept) {
              items!.add(keys[i]);
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error loading concept data: $e");
    }
  }

  Future<void> loadDataToEdit(
      {required LessonModel lesson, LessonMaterialModel? material}) async {
    try {
      ConceptMapModel? conceptMapModel =
          await ConceptMapService().getConceptMap(lesson.courseID!);
      List<String> keys = conceptMapModel!.conceptMap!.keys.toList();
      Map<String, List<int>> map = conceptMapModel.conceptMap!;
      selectedItems = [];
      if (material == null) {
        items = keys;
        selectedItems = lesson.concepts;
      } else {
        items = [];
        for (var concept in lesson.concepts!) {
          items!.add("$concept(main)");
          List<int> val = map[concept]!;
          for (int i = 0; i < val.length; i++) {
            if (val[i] == 1) {
              items!.add(keys[i]);
            }
          }
        }
        selectedItems = material.concepts;
      }
      notifyListeners();
    } catch (e) {
      print("Error loading concept data: $e");
    }
  }

  void addToSelected(String concept) {
    selectedItems!.add(concept);
    print(selectedItems);
    notifyListeners();
  }

  void removeFromSelected(String concept) {
    selectedItems!.remove(concept);
    notifyListeners();
  }

  void confirmSelected() {
    prevSelectedItems = List.from(selectedItems!);
  }

  void cancelSelected() {
    if (prevSelectedItems == null) {
      selectedItems = [];
      return;
    }
    selectedItems = List.from(prevSelectedItems!);
  }
}
