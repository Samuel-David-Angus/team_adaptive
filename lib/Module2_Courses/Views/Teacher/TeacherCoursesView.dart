import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherAddCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherJoinCourseView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../../Components/TemplateView.dart';
import '../../../Components/TopRightOptions.dart';
import '../../Models/CourseModel.dart';
import '../../View_Models/TeacherCourseViewModel.dart';

class TeacherCoursesView extends StatefulWidget {
  const TeacherCoursesView({super.key});

  @override
  _TeacherCoursesViewState createState() => _TeacherCoursesViewState();
}

class _TeacherCoursesViewState extends State<TeacherCoursesView> {
  final TextEditingController textController = TextEditingController();
  bool isCodeIncorrect = false;

  @override
  Widget build(BuildContext context) {
    TeacherCourseViewModel viewModel =
        Provider.of<TeacherCourseViewModel>(context);

    return TemplateView(
        highlighted: SELECTED.COURSES,
        topRight: userInfo(context),
        child: SingleChildScrollView(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  child: FutureBuilder<List<Course>?>(
                    future: viewModel.getCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 50, // Set the desired width
                            height: 50, // Set the desired height
                            child: CircularProgressIndicator(),
                          ),
                        );
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
                                Container(
                                  width: 365,
                                  height: 235,
                                  decoration: BoxDecoration(
                                    color: ThemeColor.darkgreyTheme,
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded edges
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            addCourseDialog(context, viewModel);
                                          },
                                          child: const Text('Add Course')),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                          onPressed: () {
                                            joinCourseDialog(context, viewModel);
                                          },
                                          child: const Text('Join Course'))
                                    ],
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
                                          Navigator.pushNamed(
                                            context,
                                            '/courseOverview',
                                            arguments: courses[index],
                                          );
                                        },
                                        child: Container(
                                          width: 365,
                                          height: 235,
                                          decoration: BoxDecoration(
                                            color: ThemeColor.lightgreyTheme,
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Rounded edges
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
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
                ))));
  }
  
  void addCourseDialog(BuildContext context, TeacherCourseViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: TeacherAddCourseView(),
        );
      },
    );
  }

  void joinCourseDialog(BuildContext context, TeacherCourseViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: TeacherJoinCourseView(),
        );
      },
    );
  }
}
