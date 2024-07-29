
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';

class TeacherQuestionView extends StatelessWidget {
  final String lessonID;
  const TeacherQuestionView({super.key, required this.lessonID});

  @override
  Widget build(BuildContext context) {
    final TeacherQuestionViewModel viewModel = Provider.of<TeacherQuestionViewModel>(context);
    return TemplateView(highlighted: SELECTED.NONE, topRight: userInfo(context), child: FutureBuilder<void>(
        future: viewModel.initializeViewModel(lessonID),
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
                      const TabBar(
                          tabs: [
                            Tab(
                              text: "My Questions",
                            ),
                            Tab(
                              text: "Other Questions",
                            )
                          ]
                      ),
                      Expanded(
                          child: TabBarView(
                              children: [
                                questionListView(viewModel.myQuestionPool, true),
                                questionListView(viewModel.otherQuestionPool, false),
                              ]
                          )
                      )
                    ],
                  ),
                )
            );
          }
        }
    ));
  }
}

Widget questionListView(List<QuestionModel> questionList, bool canEdit) {
  return Consumer<TeacherQuestionViewModel>(
      builder: (context, viewModel, child) {
        return Wrap(
          spacing: 10,
          children: List.generate(
              questionList.length,
                  (index) {
                QuestionModel question = questionList[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              choiceOption(question.correctAnswer, Colors.green),
                              ...question.wrongChoices.map((choice) {
                                return choiceOption(choice, Colors.red);
                              }),
                            ]
                        ),
                        if (canEdit) Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle button press
                            },
                            child: const Text(''),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      }
  );
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

