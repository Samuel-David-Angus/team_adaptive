import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherAddLearningObjectivesView extends StatefulWidget {
  final String lessonID;
  const TeacherAddLearningObjectivesView({super.key, required this.lessonID});

  @override
  State<TeacherAddLearningObjectivesView> createState() =>
      _TeacherAddLearningObjectivesViewState();
}

class _TeacherAddLearningObjectivesViewState
    extends State<TeacherAddLearningObjectivesView> {
  final Map<String, List<String>> levelsAndVerbs = bloomsTaxonomy;
  late String selectedLevel = levelsAndVerbs.keys.elementAt(0);
  late String selectedVerb = levelsAndVerbs.values.elementAt(0).first;
  TextEditingController textEditingController = TextEditingController();
  String? errorText;
  double acceptableFailureRate = 0.4;

  void setSelectedLevel(String value) {
    setState(() {
      selectedLevel = value;
      selectedVerb = levelsAndVerbs[value]![0];
    });
  }

  void setSelectedVerb(String value) {
    setState(() {
      selectedVerb = value;
    });
  }

  bool addLearningOutcome() {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.trim() == '') {
      setState(() {
        errorText = "Learning outcome must not be empty";
      });
      return false;
    }
    String lO = "$selectedVerb ${textEditingController.text}";
    if (!Provider.of<ConceptMapViewModel>(context, listen: false)
        .addLocalLearningOutcome(lO, acceptableFailureRate, widget.lessonID)) {
      setState(() {
        errorText = "This learning outcome already exists";
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: SingleChildScrollView(
            child: SizedBox(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text("Bloom's Taxonomy Level: "),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButton<String>(
                              value: selectedLevel,
                              items: levelsAndVerbs.keys
                                  .map((String level) =>
                                      DropdownMenuItem<String>(
                                          value: level, child: Text(level)))
                                  .toList(),
                              onChanged: (String? value) {
                                setSelectedLevel(value!);
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
                                value: selectedVerb,
                                items: levelsAndVerbs[selectedLevel]!
                                    .map((String verb) =>
                                        DropdownMenuItem<String>(
                                            value: verb, child: Text(verb)))
                                    .toList(),
                                onChanged: (String? value) {
                                  setSelectedVerb(value!);
                                }),
                            SingleChildScrollView(
                                child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 280),
                              child: TextFormField(
                                controller: textEditingController,
                                decoration: InputDecoration(
                                    hintText:
                                        "Complete the learning outcome here",
                                    errorText: errorText),
                                // onChanged: (String value) {
                                //   checkIfValid(value);
                                // },
                              ),
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text("Acceptable Failure Rate"),
                            Slider(
                                min: 0,
                                max: 100,
                                divisions: 20,
                                value: acceptableFailureRate * 100,
                                onChanged: (double value) {
                                  setState(() {
                                    acceptableFailureRate = value / 100;
                                  });
                                }),
                            Text(
                                "${(acceptableFailureRate * 100).toStringAsFixed(2)}%")
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (addLearningOutcome()) {
                                    Navigator.pop(context,
                                        "$selectedVerb ${textEditingController.text}");
                                  }
                                  ;
                                },
                                child: const Text("Add Learning Outcome",
                                    style: TextStyle(
                                        color: ThemeColor.darkgreyTheme)))),
                      ],
                    )))));
  }
}

const Map<String, List<String>> bloomsTaxonomy = {
  'Remember': [
    'List',
    'Define',
    'Describe',
    'Identify',
    'Recall',
    'Name',
    'Recognize'
  ],
  'Understand': [
    'Summarize',
    'Explain',
    'Paraphrase',
    'Classify',
    'Compare',
    'Interpret'
  ],
  'Apply': ['Use', 'Implement', 'Carry out', 'Execute', 'Solve', 'Apply'],
  'Analyze': [
    'Differentiate',
    'Organize',
    'Attribute',
    'Compare',
    'Contrast',
    'Examine',
    'Test'
  ],
  'Evaluate': [
    'Judge',
    'Critique',
    'Assess',
    'Defend',
    'Support',
    'Conclude',
    'Justify'
  ],
};
