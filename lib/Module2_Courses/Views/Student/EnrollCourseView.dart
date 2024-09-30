import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../View_Models/StudentCourseViewModel.dart';

class EnrollCourseView extends StatefulWidget {
  const EnrollCourseView({super.key});

  @override
  _EnrollCourseView createState() => _EnrollCourseView();
}

class _EnrollCourseView extends State<EnrollCourseView> {
  final TextEditingController textController = TextEditingController();
  bool isCodeIncorrect = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel = Provider.of<StudentCourseViewModel>(context);
    return SizedBox(
      height: 200.0,
      width: 400.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Enroll course',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          if (isCodeIncorrect)
            Column(
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              bool enrolled = await viewModel.enroll(textController.text);
              if (enrolled) {
                Navigator.pushNamed(context, '/Courses');
              } else {
                showErrorMessage('Incorrect code');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              backgroundColor: ThemeColor.darkgreyTheme,
            ),
            child: const Text(
              "Enroll",
              style: TextStyle(
                color: ThemeColor.offwhiteTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showErrorMessage(String message) {
    setState(() {
      isCodeIncorrect = true;
      errorMessage = message;
    });
  }
}
