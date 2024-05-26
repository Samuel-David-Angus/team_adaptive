import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';

import '../../View_Models/StudentCourseViewModel.dart';

class EnrollCourseView extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  EnrollCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel = Provider.of<StudentCourseViewModel>(context);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration (
                  border: OutlineInputBorder(),
                  hintText: 'Enter a Course ID'
                ),
                controller: textController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool enrolled = await viewModel.enroll(textController.text);
                    if (enrolled) {
                      Navigator.pushNamed(context, '/Courses');
                    } else {
                      msgDialogShow(context, 'Enrolling failed. Pls check the id');
                    }
                  },
                  child: const Text('Enroll')),
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
