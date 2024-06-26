import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';

import '../../Models/CourseModel.dart';

class TeacherAddCourseView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TeacherAddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final TeacherCourseViewModel viewModel = Provider.of<TeacherCourseViewModel>(context);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Add Course'),
              TextField(
                decoration: const InputDecoration (
                    border: OutlineInputBorder(),
                    hintText: 'Title'
                ),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration (
                    border: OutlineInputBorder(),
                    hintText: 'Code'
                ),
                controller: codeController,
              ),
              TextField(
                decoration: const InputDecoration (
                    border: OutlineInputBorder(),
                    hintText: 'Description'
                ),
                controller: descriptionController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (viewModel.validate(titleController.text, codeController.text, descriptionController.text)) {
                      Course course =  Course.setAll(
                          id: null,
                          title: titleController.text,
                          code: codeController.text,
                          description: descriptionController.text,
                          students: [],
                          teachers: [AuthServices().userInfo?.id ?? '']);
                      Course? added = await viewModel.addCourse(course);
                      if (added != null) {
                        Navigator.pushNamed(context, '/courseOverview', arguments: added);
                      } else {
                        msgDialogShow(context, "Course failed to eb added");
                      }
                    } else {
                      msgDialogShow(context, "Pls check the inputted info");
                    }
                  },
                  child: const Text('Add Course'))
            ],
          ),
        ));
  }
  void msgDialogShow(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
