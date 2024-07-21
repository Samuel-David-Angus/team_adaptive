import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel_old.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';

class SelectConceptsViewModel extends ChangeNotifier{
  List<String>? items;
  List<String>? selectedItems;

  Future<void> loadDataToAdd({String? courseID, LessonModel? lesson}) async {
    try {
      assert(courseID != null || lesson != null);
      ConceptMapModel? conceptMapModel = await ConceptMapService().getConceptMap(courseID ?? lesson!.courseID!);
      List<String> keys = conceptMapModel!.conceptMap!.keys.toList();
      Map<String, List<int>> map = conceptMapModel.conceptMap!;
      selectedItems = [];
      if (lesson == null) {
        items = keys;
      } else {
        items = [];
        for (var concept in lesson.concepts!) {
              items!.add("$concept(main)");
              print(concept);
              List<int> val = map[concept]!;
              print(val);
              for (int i = 0; i < val.length; i++) {
                if (val[i] == 1) {
                  print(keys[i]);
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

  Future<void> loadDataToEdit({required LessonModel lesson, LessonMaterialModel? material}) async {
    try {
      ConceptMapModel? conceptMapModel = await ConceptMapService().getConceptMap(lesson.courseID!);
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
    notifyListeners();
  }

  void removeFromSelected(String concept) {
    selectedItems!.remove(concept);
    notifyListeners();
  }

  void resetToNull() {
    items = null;
    selectedItems = null;
  }

}