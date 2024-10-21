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

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<TeacherLessonViewModel>(context, listen: false);
    lessonID = viewModel.getLessonID(widget.course.id!);
    conceptMapViewModel =
        Provider.of<ConceptMapViewModel>(context, listen: false);
    conceptMapViewModel.getConceptMap(widget.course.id!);
    //TODO: pls add guard whenenver it fails to load
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 3 - 20,
          height: MediaQuery.of(context).size.height / 2 - 40,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  controller: pageController,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Lesson",
                          style: TextStyle(
                              fontSize: 64, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Title'),
                          controller: titleController,
                        ),
                        const SizedBox(height: 30.0),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description'),
                          controller: descriptionController,
                          maxLines: 10,
                        ),
                        const SizedBox(height: 50.0),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    LearningOutcomeMapView(
                      lessonID: lessonID,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentIndex > 0) {
                        pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<String>? lOs = conceptMapViewModel
                          .map?.lessonPartitions[lessonID]!
                          .where((lo) => !lo.startsWith("@"))
                          .toList();
                      if (lOs != null &&
                          lOs.isNotEmpty &&
                          titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty) {
                        List<bool> check = await Future.wait([
                          viewModel.addLesson(
                              titleController.text,
                              descriptionController.text,
                              widget.course.id!,
                              lOs,
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
                                  'Pls fill all fields and map concepts'),
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
                      backgroundColor: ThemeColor.darkgreyTheme, // Padding
                    ),
                    child: const Text('Save',
                        style: TextStyle(color: ThemeColor.offwhiteTheme)),
                  ),
                  IconButton(
                    onPressed: () {
                      if (currentIndex < 1) {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
