import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherAddCourseView extends StatefulWidget {
  const TeacherAddCourseView({super.key});

  @override
  _TeacherAddCourseViewState createState() => _TeacherAddCourseViewState();
}

class _TeacherAddCourseViewState extends State<TeacherAddCourseView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isTextFieldsIncorrect = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final TeacherCourseViewModel? teacherCourseViewModel = Provider.of<TeacherCourseViewModel?>(context);
    // final ConceptMapViewModel? conceptMapViewModel = Provider.of<ConceptMapViewModel?>(context, listen: false);

    // if (teacherCourseViewModel == null || conceptMapViewModel == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // Debugging prints
    // debugPrint('TeacherCourseViewModel.map: ${conceptMapViewModel.map}');
    // debugPrint('ConceptMapViewModel.map: ${conceptMapViewModel.map}');
    debugPrint('AuthServices().userInfo: ${AuthServices().userInfo}');

    return SizedBox(
      height: 490.0,
      width: 900.0,
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Add Course',
            style: TextStyle(
              fontSize: 20.0,
            )
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          ThemeColor.offwhiteTheme), // Change the outline color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeColor
                          .lightgreyTheme), // Change the outline color when focused
                ),
                fillColor:
                    ThemeColor.offwhiteTheme, // Change the background color
                filled: true, // Enable the background color
                hintText: 'Title',
              ),
              controller: titleController,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          ThemeColor.offwhiteTheme), // Change the outline color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeColor
                          .lightgreyTheme), // Change the outline color when focused
                ),
                fillColor:
                    ThemeColor.offwhiteTheme, // Change the background color
                filled: true, // Enable the background color
                hintText: 'Code',
              ),
              controller: codeController,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: SizedBox(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeColor
                            .offwhiteTheme),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeColor
                            .lightgreyTheme),
                  ),
                  fillColor:
                      ThemeColor.offwhiteTheme,
                  filled: true,
                  hintText: 'Description',
                ),
                controller: descriptionController,
                maxLines: null,
                minLines: 7,
              ),
            ),
          ),
          if (isTextFieldsIncorrect)
            Column(children: [
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            ]),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: ElevatedButton(
                    onPressed: () async {
                      if (teacherCourseViewModel!.validate(
                          titleController.text,
                          codeController.text,
                          descriptionController.text)) {
                        Course course = Course.setAll(
                          id: null,
                          title: titleController.text,
                          code: codeController.text,
                          description: descriptionController.text,
                          students: [],
                          teachers: [AuthServices().userInfo?.id ?? ''],
                        );
                        Course? added = await teacherCourseViewModel.addCourse(course);
                        if (added != null) {
                          Navigator.pushNamed(context, '/courseOverview',
                              arguments: added);
                        } else {
                          showErrorMessage("Course failed to be added");
                        }
                      } else {
                        showErrorMessage("Please check the input fields");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      backgroundColor: ThemeColor.darkgreyTheme,
                    ),
                    child: const Text(
                      'Add Course',
                      style: TextStyle(
                          color: ThemeColor.offwhiteTheme, fontSize: 16.0
                          )
                        )
                      ),
              )
            ],
          )
        ]
      )
    );
  }

  void showErrorMessage(String message) {
    errorMessage = message;
    setState(() {
      isTextFieldsIncorrect = true;
    });
  }
}