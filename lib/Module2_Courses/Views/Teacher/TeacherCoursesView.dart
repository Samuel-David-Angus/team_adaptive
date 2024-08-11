import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../../../Components/TemplateView.dart';
import '../../../Components/TopRightOptions.dart';
import '../../Models/CourseModel.dart';
import '../../View_Models/TeacherCourseViewModel.dart';

class TeacherCoursesView extends StatelessWidget {
  const TeacherCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherCourseViewModel viewModel = Provider.of<TeacherCourseViewModel>(context);

    return TemplateView(
        highlighted: SELECTED.COURSES,
        topRight: userInfo(context),
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
                      spacing: 50.0,
                      alignment: WrapAlignment.center,
                      children: [ Container(
                          width: MediaQuery.of(context).size.width / 5 - 20,
                          height: MediaQuery.of(context).size.height / 4 - 20,
                          decoration: BoxDecoration(
                            color: ThemeColor.darkgreyTheme,
                            borderRadius: BorderRadius.circular(12.0), // Rounded edges
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
                                    Navigator.pushNamed(context, '/addCourse');
                                  },
                                  child: const Text('Add Course')
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/joinCourse');
                                  },
                                  child: const Text('Join Course')
                              )
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
                                  width: MediaQuery.of(context).size.width / 5 - 20,
                                  height: MediaQuery.of(context).size.height / 4 - 20,
                                  decoration: BoxDecoration(
                                    color: ThemeColor.lightgreyTheme,
                                    borderRadius: BorderRadius.circular(12.0), // Rounded edges
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3), // changes position of shadow
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
        )
      );
  }
}
