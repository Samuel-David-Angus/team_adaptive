import 'package:flutter/material.dart';

import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';
import '../../Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import '../../Module5_Teacher_Concept_Map/Services/ConceptMapService.dart';
import '../Models/LessonMaterialModel.dart';
import './AtomicInputMaterialInfoViewModel.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

class InitialAddMaterialsViewModel extends ChangeNotifier {
  TeacherLessonService service = TeacherLessonService();
  AuthServices authservice = AuthServices();
  ConceptMapService conceptMapService = ConceptMapService();
  int _index = 0;

  int get index => _index;

  set index(int val) {
    _index = val;
    notifyListeners();
  }

  List<AtomicInputMaterialViewModel> initialMaterials = [];
  late Future<List<String>> prereqs;

  Future<bool> addMultipleMaterials(LessonModel lesson) {
    List<LessonMaterialModel> materials = initialMaterials.map((item) {
      return createLessonMaterial(item, lesson.id!);
    }).toList();
    return service.addMultipleLessonMaterials(
        lesson.courseID!, lesson.id!, materials);
  }

  bool validate() {
    if (initialMaterials.isEmpty) {
      return false;
    }
    for (var viewModel in initialMaterials) {
      if (!viewModel.validate()) {
        return false;
      }
    }
    return true;
  }

  LessonMaterialModel createLessonMaterial(
      AtomicInputMaterialViewModel viewModel, String lessonID) {
    var lessonMaterial = LessonMaterialModel();

    lessonMaterial.title = viewModel.titleController.text;
    lessonMaterial.lessonID = lessonID;
    lessonMaterial.author = authservice.userInfo!.id!;
    lessonMaterial.src = viewModel.linkController.text;
    lessonMaterial.learningStyle = viewModel.learningStyle;
    lessonMaterial.concepts = viewModel.concepts;
    lessonMaterial.type = viewModel.type;
    return lessonMaterial;
  }

  Future<List<String>> getPrereqs(
      String courseID, List<String> concepts) async {
    ConceptMapModel? conceptMapModel =
        await conceptMapService.getConceptMap(courseID);
    List<String> prereqs = [];
    for (var concept in concepts) {
      for (int i = 0; i < conceptMapModel!.conceptMap[concept]!.length; i++) {
        if (conceptMapModel.conceptMap[concept]![i] == 1) {
          String val = conceptMapModel.conceptOfIndex(i);
          if (!prereqs.contains(val)) {
            prereqs.add(conceptMapModel.conceptOfIndex(i));
          }
        }
      }
    }
    return prereqs;
  }

  void setPrereqs(String courseID, List<String> concepts) {
    prereqs = getPrereqs(courseID, concepts);
  }
}
