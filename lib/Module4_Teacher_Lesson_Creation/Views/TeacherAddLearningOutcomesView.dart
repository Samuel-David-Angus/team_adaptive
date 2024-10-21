import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';

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
  String? errorText = "Please type a learning outcome";
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

  void checkIfValid(String value) {
    setState(() {
      errorText = null;
      if (value.isEmpty) {
        errorText = "Learning outcome must not be empty";
      }
    });
  }

  void addLearningOutcome() {
    if (textEditingController.text.isEmpty) {
      return;
    }
    String lO = "$selectedVerb ${textEditingController.text}";
    if (!Provider.of<ConceptMapViewModel>(context, listen: false)
        .addLocalLearningOutcome(lO, acceptableFailureRate, widget.lessonID)) {
      setState(() {
        errorText = "This learning outcome already exists";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              value: selectedLevel,
              items: levelsAndVerbs.keys
                  .map((String level) => DropdownMenuItem<String>(
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
                    .map((String verb) => DropdownMenuItem<String>(
                        value: verb, child: Text(verb)))
                    .toList(),
                onChanged: (String? value) {
                  setSelectedVerb(value!);
                }),
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "Complete the learning outcome here",
                    errorText: errorText),
                onChanged: (String value) {
                  checkIfValid(value);
                },
              ),
            )
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
            Text("${(acceptableFailureRate * 100).toStringAsFixed(2)}%")
          ],
        ),
        ElevatedButton(
            onPressed: () {
              addLearningOutcome();
              Navigator.pop(
                  context, "$selectedVerb ${textEditingController.text}");
            },
            child: const Text("Add Learning Outcome")),
      ],
    );
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
    'Interpret',
    'Discuss'
  ],
  'Apply': [
    'Use',
    'Implement',
    'Carry out',
    'Execute',
    'Solve',
    'Demonstrate',
    'Apply'
  ],
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
  'Create': [
    'Design',
    'Construct',
    'Develop',
    'Formulate',
    'Build',
    'Invent',
    'Compose'
  ],
};
