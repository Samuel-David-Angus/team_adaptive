import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/LearningOutcomeMapView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../Module2_Courses/Models/CourseModel.dart';

class TeacherAddLessonView extends StatefulWidget {
  final Course course;

  const TeacherAddLessonView({super.key, required this.course});

  @override
  State<TeacherAddLessonView> createState() => _TeacherAddLessonViewState();
}

class _TeacherAddLessonViewState extends State<TeacherAddLessonView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final PageController pageController = PageController();
  late final String lessonID;
  int currentIndex = 0;
  late final TeacherLessonViewModel viewModel;
  late final ConceptMapViewModel conceptMapViewModel;
  late LearningOutcomeMapView learningOutcomeMapView;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<TeacherLessonViewModel>(context, listen: false);
    lessonID = viewModel.getLessonID(widget.course.id!);
    conceptMapViewModel =
        Provider.of<ConceptMapViewModel>(context, listen: false);
    conceptMapViewModel.getConceptMap(widget.course.id!);
    learningOutcomeMapView =
        LearningOutcomeMapView(lessonID: lessonID, courseID: widget.course.id!);
    //TODO: pls add guard whenenver it fails to load
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add Lesson",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.darkgreyTheme),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .offwhiteTheme), // Change the outline color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
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
                  )),
              const SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Flexible(
                    flex: 1,
                    child: SizedBox(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Description', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10.0),
                        TextField(
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
                            filled: true,
                            hintText: "Start here...",
                          ),
                          controller: descriptionController,
                          maxLines: 22,
                          
                        ),
                      ],
                    ))),
                const SizedBox(width: 50),
                SizedBox(
                    height: 600,
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: learningOutcomeMapView)
              ]),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    List<String>? lOs = conceptMapViewModel
                        .map?.lessonPartitions[lessonID]
                        ?.where((lo) => !lo.startsWith("@"))
                        .toList();
                    if (lOs != null &&
                        lOs.isNotEmpty &&
                        titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      List<bool> check = await Future.wait([
                        viewModel.addLesson(titleController.text,
                            descriptionController.text, widget.course.id!, lOs,
                            lessonID: lessonID),
                        conceptMapViewModel.saveEdits(lessonID)
                      ]);
                      if (check[0] && check[1]) {
                        viewModel.allLessons =
                            viewModel.getLessonByCourse(widget.course.id!);
                        viewModel.refresh();
                        context.go('/courses/${widget.course.id}/lessons',
                            extra: widget.course);
                      } else {
                        print('uh oh something went wrong');
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Message'),
                            content: const Text(
                                'Please fill all fields and add learning outcomes.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.darkgreyTheme,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50), // Padding
                  ),
                  child: const Text('Save',
                      style: TextStyle(color: ThemeColor.offwhiteTheme,
                      fontSize: 21)),
                ),
              )
            ],
          ),
        ));
  }
}
