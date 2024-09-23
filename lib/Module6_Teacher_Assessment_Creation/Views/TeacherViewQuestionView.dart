import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherViewQuestionView extends StatelessWidget {
  final LessonModel lesson;
  const TeacherViewQuestionView({super.key, required this.lesson});

  Widget questionListView(List<QuestionModel> questionList, bool canEdit) {
    return Consumer<TeacherQuestionViewModel>(
        builder: (context, viewModel, child) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          children: List.generate(questionList.length, (index) {
            QuestionModel question = questionList[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          choiceOption(question.correctAnswer, Colors.green),
                          ...question.wrongChoices.map((choice) {
                            return choiceOption(choice, Colors.red);
                          }),
                        ]),
                    if (canEdit)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go(
                                    '/courses/${lesson.courseID}/lessons/${lesson.id}/questions/edit/${question.id}',
                                    extra: (question, lesson));
                              },
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.deleteQuestion(question);
                              },
                              child: const Text('Delete'),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget choiceOption(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank_sharp,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TeacherQuestionViewModel viewModel =
        Provider.of<TeacherQuestionViewModel>(context, listen: false);
    return FutureBuilder<void>(
        future: viewModel.initializeViewModel(lesson.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return DefaultTabController(
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50.0),
                      SizedBox(
                        width: 150.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).go('/courses/${lesson.courseID}/lessons/${lesson.id}/questions/add',extra: lesson);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.darkgreyTheme,
                          ),
                          child: const Text(
                            '+ Add Question',
                            style: TextStyle(
                              color: ThemeColor.offwhiteTheme,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      const TabBar(tabs: [
                        Tab(
                          text: "My Questions",
                        ),
                        Tab(
                          text: "Other Questions",
                        )
                      ]),
                      Expanded(
                          child: TabBarView(children: [
                        questionListView(viewModel.myQuestionPool, true),
                        questionListView(
                            viewModel.otherQuestionPool, false),
                      ]))
                    ],
                  ),
                ));
          }
        });
  }
}
