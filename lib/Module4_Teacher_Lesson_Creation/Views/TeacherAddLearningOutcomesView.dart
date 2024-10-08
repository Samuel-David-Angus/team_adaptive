import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLearningOutcomesViewModel.dart';

class TeacherAddLearningObjectivesView extends StatelessWidget {
  final _scrollBarController = ScrollController();
  TeacherAddLearningObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherAddLearningOutcomesViewModel>(
        builder: (context, viewModel, child) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Bloom's Taxonomy Level: "),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  value: viewModel.selectedLevel,
                  items: TeacherAddLearningOutcomesViewModel.levelsAndVerbs.keys
                      .map((String level) => DropdownMenuItem<String>(
                          value: level, child: Text(level)))
                      .toList(),
                  onChanged: (String? value) {
                    viewModel.setSelectedLevel(value!);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                    value: viewModel.selectedVerb,
                    items: TeacherAddLearningOutcomesViewModel
                        .levelsAndVerbs[viewModel.selectedLevel]!
                        .map((String verb) => DropdownMenuItem<String>(
                            value: verb, child: Text(verb)))
                        .toList(),
                    onChanged: (String? value) {
                      viewModel.setSelectedVerb(value!);
                    }),
                Expanded(
                  child: TextFormField(
                    controller: viewModel.textEditingController,
                    decoration: InputDecoration(
                        hintText: "Complete the learning outcome here",
                        errorText: viewModel.errorText),
                    onChanged: (String value) {
                      viewModel.checkIfValid(value);
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  viewModel.addLearningOutcome();
                },
                child: const Text("Add Learning Outcome")),
            const SizedBox(
              height: 20,
            ),
            const Text("Learning outcomes: "),
            const SizedBox(
              height: 20,
            ),
            Text(
                "Count: ${viewModel.learningOutcomesAndPassingFailureRate.length}"),
            const SizedBox(
              height: 20,
            ),
            if (viewModel.learningOutcomesAndPassingFailureRate.isNotEmpty)
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(border: Border.all()),
                height: 200,
                width: 600,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollBarController,
                  child: ListView.builder(
                      controller: _scrollBarController,
                      itemCount: viewModel
                          .learningOutcomesAndPassingFailureRate.length,
                      itemBuilder: (context, index) {
                        String lO = viewModel
                            .learningOutcomesAndPassingFailureRate.keys
                            .elementAt(index);
                        return LearningOutcomeTile(
                            viewModel: viewModel, learningOutcome: lO);
                      }),
                ),
              )
          ],
        ),
      );
    });
  }
}

class LearningOutcomeTile extends StatefulWidget {
  final TeacherAddLearningOutcomesViewModel viewModel;
  final String learningOutcome;
  const LearningOutcomeTile(
      {super.key, required this.viewModel, required this.learningOutcome});

  @override
  State<LearningOutcomeTile> createState() => _LearningOutcomeTileState();
}

class _LearningOutcomeTileState extends State<LearningOutcomeTile> {
  late final TeacherAddLearningOutcomesViewModel viewModel;
  late final String learningOutcome;
  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    learningOutcome = widget.learningOutcome;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            viewModel.deleteLearningOutcome(learningOutcome);
          },
        ),
        title: Text(learningOutcome),
        subtitle: Row(
          children: [
            const Text("Acceptable Failure Rate"),
            Slider(
                min: 0,
                max: 100,
                divisions: 20,
                value: viewModel.learningOutcomesAndPassingFailureRate[
                        learningOutcome]! *
                    100,
                onChanged: (double value) {
                  setState(() {
                    viewModel.updateLOFailureRate(learningOutcome, value / 100);
                  });
                }),
            Text(
                "${(viewModel.learningOutcomesAndPassingFailureRate[learningOutcome]! * 100).toStringAsFixed(2)}%")
          ],
        ),
      ),
    );
  }
}
