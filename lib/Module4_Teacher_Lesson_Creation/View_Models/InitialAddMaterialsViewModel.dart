import 'package:flutter/material.dart';

import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';
import '../Models/LessonMaterialModel.dart';
import './AtomicInputMaterialInfoViewModel.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

class InitialAddMaterialsViewModel extends ChangeNotifier {
  TeacherLessonService service = TeacherLessonService();
  AuthServices authservice = AuthServices();

  List<AtomicInputMaterialViewModel> initialMaterials = [];

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
    lessonMaterial.learningStyle = viewModel.selectStyleViewModel.selectedStyle;
    lessonMaterial.concepts = viewModel.selectConceptsViewModel.selectedItems;
    lessonMaterial.type = viewModel.type;
    return lessonMaterial;
  }
}
