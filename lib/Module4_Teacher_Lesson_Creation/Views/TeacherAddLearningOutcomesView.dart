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
            Text("Count: ${viewModel.learningOutcomes.length}"),
            const SizedBox(
              height: 20,
            ),
            if (viewModel.learningOutcomes.isNotEmpty)
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(border: Border.all()),
                height: 200,
                width: 500,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollBarController,
                  child: ListView.builder(
                      controller: _scrollBarController,
                      itemCount: viewModel.learningOutcomes.length,
                      itemBuilder: (context, index) => Card(
                            child: ListTile(
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  viewModel.deleteLearningOutcome(index);
                                },
                              ),
                              title: Text(viewModel.learningOutcomes[index]),
                            ),
                          )),
                ),
              )
          ],
        ),
      );
    });
  }
}
