import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Views/TeacherAddQuestionView.dart';

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
                          if (question.numberOfCorrectAnswers + question.numberOfWrongAnswers > 0) ...
                            [Text("${question.numberOfCorrectAnswers / (question.numberOfCorrectAnswers + question.numberOfWrongAnswers) * 100}% got this correct"),
                            Text("Difficulty level: ${question.adjustedDifficulty}")]
                          else ... [
                            const Text("No one has answered this question yet"),
                            Text("Difficulty level: ${question.baseDifficulty}")
                          ]
                        ]),
                    if (canEdit)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherAddQuestionView(
                                              lessonModel: lesson,
                                              question: question,
                                            )));
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
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: FutureBuilder<void>(
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
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherAddQuestionView(
                                                lessonModel: lesson)));
                              },
                              child: const Text('Add Question')),
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
            }));
  }
}
