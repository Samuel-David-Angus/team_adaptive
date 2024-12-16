import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherAddCourseView extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TeacherAddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final TeacherCourseViewModel? teacherCourseViewModel =
        Provider.of<TeacherCourseViewModel?>(context);
    final ConceptMapViewModel? conceptMapViewModel =
        Provider.of<ConceptMapViewModel?>(context, listen: false);

    if (teacherCourseViewModel == null || conceptMapViewModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AlertDialog(
        shadowColor: ThemeColor.darkgreyTheme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: ThemeColor.darkgreyTheme,),
          child: Wrap(
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(children: [
                      const Text('Add Course',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.offwhiteTheme,
                          )),
                      const SizedBox(height: 50.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeColor
                                      .offwhiteTheme), // Change the outline color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeColor
                                      .lightgreyTheme), // Change the outline color when focused
                            ),
                            fillColor: ThemeColor
                                .offwhiteTheme, // Change the background color
                            filled: true, // Enable the background color
                            hintText: 'Title',
                          ),
                          controller: titleController,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeColor
                                      .offwhiteTheme), // Change the outline color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeColor
                                      .lightgreyTheme), // Change the outline color when focused
                            ),
                            fillColor: ThemeColor
                                .offwhiteTheme, // Change the background color
                            filled: true, // Enable the background color
                            hintText: 'Code',
                          ),
                          controller: codeController,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: SizedBox(
                          height: 200, // Set the desired height
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ThemeColor
                                        .offwhiteTheme), // Change the outline color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ThemeColor
                                        .lightgreyTheme), // Change the outline color when focused
                              ),
                              fillColor: ThemeColor
                                  .offwhiteTheme, // Change the background color
                              filled: true, // Enable the background color
                              hintText: 'Description',
                            ),
                            controller: descriptionController,
                            maxLines:
                                null, // Allow the text to wrap and support newlines
                            minLines: 5, // Set a minimum number of lines
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (teacherCourseViewModel.validate(
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
                                Course? added = await teacherCourseViewModel
                                    .addCourse(course);
                                if (added != null) {
                                  GoRouter.of(context)
                                      .go('/courses/${added.id}', extra: added);
                                } else {
                                  msgDialogShow(
                                      context, "Course failed to be added");
                                }
                              } else {
                                msgDialogShow(
                                    context, "Please check the inputted info");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 98, vertical: 24),
                              backgroundColor: ThemeColor.offwhiteTheme,
                            ),
                            child: const Text('Add Course',
                                style: TextStyle(
                                    color: ThemeColor.darkgreyTheme,
                                    fontSize: 16.0))),
                      )
                    ]),
                  ),
                ],
              )),
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
