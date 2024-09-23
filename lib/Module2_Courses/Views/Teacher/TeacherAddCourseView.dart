import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/ConceptMapView.dart';
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

    // Debugging prints
    debugPrint('TeacherCourseViewModel.map: ${conceptMapViewModel.map}');
    debugPrint('ConceptMapViewModel.map: ${conceptMapViewModel.map}');
    debugPrint('AuthServices().userInfo: ${AuthServices().userInfo}');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Wrap(
        children: [
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      color: ThemeColor.darkgreyTheme,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          const Text('Add Course',
                              style: TextStyle(
                                fontSize: 64,
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
                        ],
                      )),
                ]),
          ),
          ConceptMapView(course: null),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: ElevatedButton(
                    onPressed: () async {
                      if (teacherCourseViewModel.validate(
                          titleController.text,
                          codeController.text,
                          descriptionController.text,
                          conceptMapViewModel.map!)) {
                        Course course = Course.setAll(
                          id: null,
                          title: titleController.text,
                          code: codeController.text,
                          description: descriptionController.text,
                          students: [],
                          teachers: [AuthServices().userInfo?.id ?? ''],
                        );
                        Course? added =
                            await teacherCourseViewModel.addCourse(course);
                        if (added != null) {
                          await conceptMapViewModel
                              .uploadConceptMap(added.id!);
                          GoRouter.of(context)
                              .go('/courses/${added.id}', extra: added);
                        } else {
                          msgDialogShow(context, "Course failed to be added");
                        }
                      } else {
                        msgDialogShow(
                            context, "Please check the inputted info");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 98, vertical: 24),
                      backgroundColor: ThemeColor.darkgreyTheme,
                    ),
                    child: const Text('Add Course',
                        style: TextStyle(
                            color: ThemeColor.offwhiteTheme,
                            fontSize: 16.0))),
              )
            ],
          )
        ],
      ),
    );
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
