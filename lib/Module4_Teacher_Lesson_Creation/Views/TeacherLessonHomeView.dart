import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherLessonHomeView extends StatelessWidget {
  final Course course;
  const TeacherLessonHomeView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    bool justLoaded = true;
    bool isSetUpComplete = true;

    final TeacherLessonViewModel viewModel =
        Provider.of<TeacherLessonViewModel>(context);
    if (justLoaded) {
      justLoaded = false;
      viewModel.allLessons = viewModel.getLessonByCourse(course.id!);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<LessonModel>>(
        future: viewModel.allLessons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(),
                ]));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<LessonModel> lessons = snapshot.data!;
            if (lessons.any((lesson) => lesson.isSetupComplete == false)) {
              isSetUpComplete = false;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                SizedBox(
                  width: 150.0,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isSetUpComplete) {
                        GoRouter.of(context).go(
                            "/courses/${course.id}/add-lesson",
                            extra: course);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Message'),
                              content: const Text(
                                  'Cannot add lesson when there is a lesson that is not finished setting up'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
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
                      backgroundColor: isSetUpComplete ? ThemeColor.darkgreyTheme : ThemeColor.errorTheme,
                    ),
                    child: const Text(
                      '+ Add Lesson',
                      style: TextStyle(
                        color: ThemeColor.offwhiteTheme,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                Wrap(
                  spacing: 10,
                  children: List.generate(lessons.length, (index) {
                    return Card(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: !lessons[index].isSetupComplete!
                                        ? ThemeColor.errorTheme
                                        : ThemeColor.darkgreyTheme,
                                    width: 2)),
                            child: ListTile(
                              title: Row(children: [
                                Text(lessons[index].lessonTitle!),
                                const SizedBox(width: 10),
                                !lessons[index].isSetupComplete!
                                    ? const Text('(Setup Required)',
                                        style: TextStyle(
                                            color: ThemeColor.errorTheme))
                                    : const Text(''),
                              ]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  lessons[index].isSetupComplete!
                                      ? TextButton(
                                          onPressed: () {
                                            GoRouter.of(context).go(
                                                '/courses/${course.id}/lessons/${lessons[index].id}/materials',
                                                extra: lessons[index]);
                                          },
                                          child: const Text('See materials'),
                                        )
                                      : const SizedBox(width: 0),
                                  lessons[index].isSetupComplete!
                                      ? TextButton(
                                          onPressed: () {
                                            GoRouter.of(context).go(
                                                '/courses/${course.id}/lessons/${lessons[index].id}/questions',
                                                extra: lessons[index]);
                                          },
                                          child: const Text(
                                              'Create Assessment Questions'),
                                        )
                                      : const SizedBox(width: 0),
                                  if (!lessons[index].isSetupComplete!)
                                    TextButton(
                                        style: ButtonStyle(overlayColor:
                                            WidgetStateProperty.resolveWith<
                                                    Color>(
                                                (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Colors.transparent;
                                          }
                                          return Colors.transparent;
                                        }), textStyle: WidgetStateProperty
                                            .resolveWith<TextStyle>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return const TextStyle(
                                                  fontSize: 17);
                                            }
                                            return const TextStyle(
                                                fontSize: 16);
                                          },
                                        )),
                                        onPressed: () async {
                                          await context.push(
                                              '/courses/${course.id}/lessons/${lessons[index].id}/initialize',
                                              extra: lessons[index]);
                                          viewModel.refresh();
                                        },
                                        child: const Text('Setup →',
                                            style: TextStyle(
                                                color:
                                                    ThemeColor.darkgreyTheme))),
                                  if (lessons[index].isSetupComplete!)
                                    TextButton(
                                        onPressed: () {
                                          context.go(
                                              '/courses/${course.id}/lessons/${lessons[index].id}/dashboard');
                                        },
                                        child: const Text('Dashboard'))
                                ],
                              ),
                            )));
                  }),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void showAddLessonDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TeacherAddLessonView(course: course);
        });
  }
}
