import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class StudentCoursesView extends StatelessWidget {
  const StudentCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel = Provider.of<StudentCourseViewModel>(context);

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
                      children: [ 
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/joinCourse');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.transparent; // Change this to your desired hover color
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
                          )
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
        ));
  }
}
