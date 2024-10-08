import 'package:flutter/material.dart';

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

class TeacherAddLearningOutcomesViewModel extends ChangeNotifier {
  static const Map<String, List<String>> levelsAndVerbs = bloomsTaxonomy;
  String selectedLevel = levelsAndVerbs.keys.elementAt(0);
  String selectedVerb = levelsAndVerbs.values.elementAt(0).first;
  TextEditingController textEditingController = TextEditingController();
  String? errorText = "Please type a learning outcome";
  Map<String, double> learningOutcomesAndPassingFailureRate = {};

  void setSelectedLevel(String value) {
    selectedLevel = value;
    selectedVerb = levelsAndVerbs[value]![0];
    notifyListeners();
  }

  void setSelectedVerb(String value) {
    selectedVerb = value;
    notifyListeners();
  }

  void addLearningOutcome() {
    if (textEditingController.text.isEmpty) {
      return;
    }
    String lO = "$selectedVerb ${textEditingController.text}";
    if (!learningOutcomesAndPassingFailureRate.containsKey(lO)) {
      learningOutcomesAndPassingFailureRate[lO] = 0.4;
    } else {
      errorText = "This learning outcome already exists";
    }
    notifyListeners();
  }

  void checkIfValid(String value) {
    errorText = null;
    if (value.isEmpty) {
      errorText = "Learning outcome must not be empty";
    }
    notifyListeners();
  }

  void deleteLearningOutcome(String lO) {
    learningOutcomesAndPassingFailureRate.remove(lO);
    notifyListeners();
  }

  void updateLOFailureRate(String lO, double value) {
    learningOutcomesAndPassingFailureRate[lO] = value;
  }
}
