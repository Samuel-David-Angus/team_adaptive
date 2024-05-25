import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';

class StudentCoursesView extends StatelessWidget {
  const StudentCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel = Provider.of<StudentCourseViewModel>(context);

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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/enroll');
                        },
                        child: const Text('Enroll Course')),
                    Wrap(
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
                            ));
                          }),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
