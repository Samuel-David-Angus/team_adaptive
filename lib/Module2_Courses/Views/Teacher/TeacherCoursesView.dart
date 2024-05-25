import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        topRight: userInfo(viewModel.user!, context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<List<Course>?>(
            future: viewModel.getCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or any loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Course> courses = snapshot.data!;
                return Wrap(
                  spacing: 10,
                  children: List.generate(
                      courses.length,
                          (index) {
                        return Card(
                          child: ListTile(
                            title: Text(courses[index].title!),
                            subtitle: Text(courses[index].code!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/courseOverview', arguments: courses[index]);
                                  },
                                  child: const Text('Enter'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            },
          ),
        ));
  }
}
