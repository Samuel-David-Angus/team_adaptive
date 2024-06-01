import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/SelectConceptsViewModel.dart';

import '../Models/LessonMaterialModel.dart';


class TeacherSelectConceptsView extends StatelessWidget {
  String? courseID;
  LessonModel? lesson;
  LessonMaterialModel? material;
  TeacherSelectConceptsView({super.key, this.courseID, this.lesson, this.material});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectConceptsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.items == null && viewModel.selectedItems == null) {
          if (courseID != null && lesson == null && material == null) {
            viewModel.loadDataToAdd(courseID: courseID);
          } else if (lesson != null && courseID == null && material == null) {
            viewModel.loadDataToAdd(lesson: lesson);
          } else if (material != null && lesson != null && courseID == null) {
            viewModel.loadDataToEdit(lesson: lesson!, material: material);
          } else if (material == null && lesson != null && courseID == null) {
            viewModel.loadDataToEdit(lesson: lesson!);
          } else {
            assert(false, "did not meet conditions for selecting concepts");
          }
        }
        if (viewModel.items == null) {
          return const CircularProgressIndicator();
        }
        return AlertDialog(
          title: Text('Select Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: viewModel.items!.map((item) {
                return CheckboxListTile(
                  title: Text(item),
                  value: viewModel.selectedItems!.contains(item),
                  onChanged: (bool? checked) {
                    if (checked == true) {
                      viewModel.addToSelected(item);
                    } else {
                      viewModel.removeFromSelected(item);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                viewModel.resetToNull();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                var results = [...?viewModel.selectedItems];
                viewModel.resetToNull();
                Navigator.of(context).pop(results);
              },
            ),
          ],
        );
      },
    );
  }
}
