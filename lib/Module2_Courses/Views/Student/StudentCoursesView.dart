import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class StudentCoursesView extends StatefulWidget {
  const StudentCoursesView({super.key});

  @override
  _StudentCoursesViewState createState() => _StudentCoursesViewState();
}

class _StudentCoursesViewState extends State<StudentCoursesView> {
  final TextEditingController textController = TextEditingController();
  bool isCodeIncorrect = false;

  void invalidCode() {
    setState(() {
      isCodeIncorrect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel =
        Provider.of<StudentCourseViewModel>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: FutureBuilder<List<Course>?>(
          future: viewModel.getCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // or any loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Course> courses = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 70.0,
                    runSpacing: 70.0,
                    alignment: WrapAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          enrollCourseDialog(
                              context, viewModel, "Enter course code");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Colors
                                    .transparent; // Change this to your desired hover color
                              }
                              return null; // Defer to the default value
                            },
                          ),
                          elevation: WidgetStateProperty.resolveWith<double>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return 0; // Change this to your desired hover elevation
                              }
                              return 0; // Defer to the default value
                            },
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5 - 20,
                          height: MediaQuery.of(context).size.height / 4 - 20,
                          decoration: BoxDecoration(
                            color: ThemeColor.darkgreyTheme,
                            borderRadius:
                                BorderRadius.circular(12.0), // Rounded edges
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: FittedBox(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: ThemeColor.offwhiteTheme,
                                      fontFamily: 'Poppins',
                                      fontSize: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Enroll Course',
                                style: TextStyle(
                                  color: ThemeColor.offwhiteTheme,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Generate dynamic widgets
                      ...List.generate(
                        courses.length,
                        (index) {
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).go(
                                    '/courses/${courses[index].id}',
                                    extra: courses[index]);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 5 -
                                    20,
                                height:
                                    MediaQuery.of(context).size.height / 4 -
                                        20,
                                decoration: BoxDecoration(
                                  color: ThemeColor.lightgreyTheme,
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Rounded edges
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${courses[index].title}\nCode: ${courses[index].code}',
                                    style: const TextStyle(
                                      color: ThemeColor.darkgreyTheme,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void enrollCourseDialog(
      BuildContext context, StudentCourseViewModel viewModel, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: 200.0,
                width: 300.0, // Set your desired width here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(message),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (isCodeIncorrect)
                      const Column(
                        children: [
                          Text(
                            'Incorrect course code',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        bool enrolled =
                            await viewModel.enroll(textController.text);
                        if (enrolled) {
                          GoRouter.of(context).go('/courses');
                        } else {
                          setState(() {
                            isCodeIncorrect = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 16),
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
              ),
            );
          },
        );
      },
    );
  }
}
