import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../View_Models/TeacherCourseViewModel.dart';

class TeacherJoinCourseView extends StatefulWidget {
  const TeacherJoinCourseView({super.key});

  @override
  _TeacherJoinCourseViewState createState() => _TeacherJoinCourseViewState();
}

class _TeacherJoinCourseViewState extends State<TeacherJoinCourseView> {
  final TextEditingController textController = TextEditingController();
  bool isCodeIncorrect = false;
  String errorMessage = '';
  
  @override
  Widget build(BuildContext context) {
    TeacherCourseViewModel viewModel = Provider.of<TeacherCourseViewModel>(context);
    
    return SizedBox(
      height: 200.0,
      width: 400.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Enter the course code',
            style: TextStyle(
              fontSize: 20.0,
            )
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          if (isCodeIncorrect)
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              bool enrolled =
                  await viewModel.joinCourse(textController.text);
              if (enrolled) {
                Navigator.pushNamed(context, '/Courses');
              } else {
                showErrorMessage('Incorrect code');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 48, vertical: 16),
              backgroundColor: ThemeColor.darkgreyTheme,
            ),
            child: const Text(
              "Enroll",
              style: TextStyle(
                color: ThemeColor.offwhiteTheme, fontSize: 16.0
              ),
            ),
          ),
        ],
      ),
    ); 
  }

  void showErrorMessage(String message) {
    errorMessage = message;
    setState(() {
      isCodeIncorrect = true;
    });
  }
}
