
import 'dart:math';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';

class QuestionModel {
  late String _authorID;
  late String _id;
  late String _question;
  late String _correctAnswer;
  late List<String> _wrongChoices;
  late String _questionConcept;
  late int _numberOfCorrectAnswers;
  late int _numberOfWrongAnswers;
  late List<String> _prerequisiteConcepts;
  late int _baseDifficulty;
  late int _adjustedDifficulty;

  // Getters
  String get authorID => _authorID;
  String get id => _id;
  String get question => _question;
  String get correctAnswer => _correctAnswer;
  List<String> get wrongChoices => _wrongChoices;
  String get questionConcept => _questionConcept;
  int get numberOfCorrectAnswers => _numberOfCorrectAnswers;
  int get numberOfWrongAnswers => _numberOfWrongAnswers;
  List<String> get prerequisiteConcepts => _prerequisiteConcepts;
  int get baseDifficulty => _baseDifficulty;
  int get adjustedDifficulty => _adjustedDifficulty;
  int get prerequisiteCount => _prerequisiteConcepts.length;

  // Setters
  set authorID(String authorID) => _authorID = authorID;
  set id(String id) => _id = id;
  set question(String question) => _question = question;
  set correctAnswer(String correctAnswer) => _correctAnswer = correctAnswer;
  set wrongChoices(List<String> wrongChoices) => _wrongChoices = wrongChoices;
  set questionConcept(String questionConcept) =>
      _questionConcept = questionConcept;
  set numberOfCorrectAnswers(int numberOfCorrectAnswers) =>
      _numberOfCorrectAnswers = numberOfCorrectAnswers;
  set numberOfWrongAnswers(int numberOfWrongAnswers) =>
      _numberOfWrongAnswers = numberOfWrongAnswers;
  set prerequisiteConcepts(List<String> prerequisiteConcepts) =>
      _prerequisiteConcepts = prerequisiteConcepts;
  set baseDifficulty(int baseDifficulty) => _baseDifficulty = baseDifficulty;
  set adjustedDifficulty(int adjustedDifficulty) =>
      _adjustedDifficulty = adjustedDifficulty;

  QuestionModel.setAll({
    required String id,
    required String authorID,
    required String question,
    required String correctAnswer,
    required List<String> wrongChoices,
    required String questionConcept,
    required int numberOfCorrectAnswers,
    required int numberOfWrongAnswers,
    required List<String> prerequisiteConcepts,
    required int baseDifficulty,
    required int adjustedDifficulty,
  })
      : _id = id,
        _authorID = authorID,
        _question = question,
        _correctAnswer = correctAnswer,
        _wrongChoices = wrongChoices,
        _questionConcept = questionConcept,
        _numberOfCorrectAnswers = numberOfCorrectAnswers,
        _numberOfWrongAnswers = numberOfWrongAnswers,
        _prerequisiteConcepts = prerequisiteConcepts,
        _baseDifficulty = baseDifficulty,
        _adjustedDifficulty = adjustedDifficulty;


  QuestionModel.newlyCreated({
    required String authorID,
    required String question,
    required String correctAnswer,
    required List<String> wrongChoices,
    required String questionConcept,
    required ConceptMapModel conceptMapModel
  })
      : _authorID = authorID,
        _question = question,
        _correctAnswer = correctAnswer,
        _wrongChoices = wrongChoices,
        _questionConcept = questionConcept,
        _numberOfCorrectAnswers = 0,
        _numberOfWrongAnswers = 0
  {
    findAllPrerequisites(conceptMapModel);
    calculateBaseDifficulty(conceptMapModel);
    calculateAdjustedDifficulty(conceptMapModel);
  }

  QuestionModel.copyFrom(QuestionModel original) :
        _id = original.id,
        _authorID = original.authorID,
        _question = original.question,
        _correctAnswer = original.correctAnswer,
        _wrongChoices = original.wrongChoices,
        _questionConcept = original.questionConcept,
        _numberOfCorrectAnswers = original.numberOfCorrectAnswers,
        _numberOfWrongAnswers = original.numberOfWrongAnswers,
        _prerequisiteConcepts = original.prerequisiteConcepts,
        _baseDifficulty = original.baseDifficulty,
        _adjustedDifficulty = original.adjustedDifficulty;

  factory QuestionModel.fromJson(Map<String, dynamic> json, String id) {
    return QuestionModel.setAll(
        id: json["id"],
        authorID: json["authorID"],
        question: json["question"],
        correctAnswer: json["correctAnswer"],
        wrongChoices: List<String>.from(json["wrongChoices"]),
        questionConcept: json["questionConcept"],
        numberOfCorrectAnswers: json["numberOfCorrectAnswers"],
        numberOfWrongAnswers: json["numberOfWrongAnswers"],
        prerequisiteConcepts: List<String>.from(json["prerequisiteConcepts"]),
        baseDifficulty: json["baseDifficulty"],
        adjustedDifficulty: json["adjustedDifficulty"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "authorID": _authorID,
      "question": _question,
      "correctAnswer": _correctAnswer,
      "wrongChoices": _wrongChoices,
      "questionConcept": _questionConcept,
      "numberOfCorrectAnswers": _numberOfCorrectAnswers,
      "numberOfWrongAnswers": _numberOfWrongAnswers,
      "prerequisiteConcepts": _prerequisiteConcepts,
      "baseDifficulty": _baseDifficulty,
      "adjustedDifficulty": _adjustedDifficulty,
    };
  }

  List<String> findAllPrerequisites(ConceptMapModel conceptMapModel) {
    List<String> foundPrerequisites = <String>[];
    conceptMapModel.findAllPrerequisites(_questionConcept, foundPrerequisites);
    _prerequisiteConcepts = foundPrerequisites;
    return foundPrerequisites;
  }

  int calculateBaseDifficulty(ConceptMapModel conceptMapModel) {
    _baseDifficulty = (prerequisiteCount * 10) ~/ conceptMapModel.conceptCount;
    return _baseDifficulty;
  }

  int calculateAdjustedDifficulty(ConceptMapModel conceptMapModel) {
    if (_baseDifficulty == null) {
      throw Exception("Base difficulty of question is still not set");
    }
    if (numberOfCorrectAnswers + numberOfWrongAnswers < 1) {
      _adjustedDifficulty = _baseDifficulty;
    } else {
      double initialDifficulty = _baseDifficulty / 10.0;
      double t = _numberOfCorrectAnswers + _numberOfWrongAnswers * 1.0;
      double k = (_numberOfWrongAnswers - _numberOfCorrectAnswers) / t;
      double changedDifficulty = initialDifficulty /
          (initialDifficulty + (1 - initialDifficulty) * exp(-k * t));
      double damping = 0.8;
      _adjustedDifficulty =
          (_baseDifficulty * damping + changedDifficulty * (1 - damping) * 10)
              .round();
    }
    return _adjustedDifficulty;
  }

}

/*
import 'dart:math';

import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherAssessmentService.dart';

class QuestionModel{
  late String _id;
  late String _sentence;
  late int _correctAnswer;
  late List<String> _choices;
  late String _relatedConcept;
  late int _totalAnswers;
  late int _rights;
  late int _wrongs;
  late int _relatedConceptCount;
  late List<int> _testItemRelationships;
  late int _difficulty;
  late int _adjustedDifficulty;
  late String _assessmentID;
  Future<AssessmentModel?> assessment;
  Future<ConceptMapModel?> conceptMap;

  // Constructor
  QuestionModel.setAll({
    required String id,
    required String sentence,
    required int correctAnswer,
    required List<String> choices,
    required String relatedConcept,
    required int rights,
    required int wrongs,
    required String conceptMapID,
    required String assessmentID
  }) {
    _id = id;
    _sentence = sentence;
    _correctAnswer = correctAnswer;
    _choices = choices;
    _relatedConcept = relatedConcept;
    _rights = rights;
    _wrongs = wrongs;

    assessment = TeacherAssessmentService.getAssessment(assessmentID);
    conceptMap = ConceptMapModel.getConceptMap(conceptMapID).then((value) => conceptMap = value);

    _totalAnswers = _rights + _wrongs;
    _relatedConceptCount = 0;
    _testItemRelationships = List.filled(conceptMap.conceptCount, 0);
    _assessmentID = assessmentID;
    // FIND ALL PREREQUISITES
    int relatedConceptIndex = conceptMap.findIndexOfConcept(relatedConcept);
    conceptMap.findPreRequisites(relatedConceptIndex, _testItemRelationships);

    // COUNT ALL PREREQUISITES
    for (int i = 0; i < conceptMap.conceptCount; i++) {
      if (_testItemRelationships[i] != 0) _relatedConceptCount++;
    }

    // SET QuestionModelDIFFICULTY RATE (QDRT)
    _difficulty = (10 * _relatedConceptCount) ~/ conceptMap.conceptCount;
    adjustDifficulty();

    // Print stuff
    List<String> letters = ["A", "B", "C", "D"];
    print("\nQuestion: $sentence");
    print("\n\tChoices:");
    for (int i = 0; i < _choices.length; i++) {
      print("\n\t${letters[i]}. ${_choices[i]}");
    }
    print("\n\tDifficulty of QuestionModel(QDRT): $_difficulty \n\tAdjusted Difficulty: $_adjustedDifficulty"
        "\n\tRelatedness of QuestionModelto Concept (TIRT):");

    // SET TEST ITEM RELATIONSHIPS (TIRT)
    int questionDepth = conceptMap.conceptDepths[relatedConceptIndex];
    for (int i = 0; i < conceptMap.conceptCount; i++) {
      if (_testItemRelationships[i] != 0) {
        _testItemRelationships[i] = (5 * conceptMap.conceptDepths[i]) ~/ questionDepth;
      }
      print("\n\t\t ${conceptMap.concepts[i]} : ${_testItemRelationships[i]}");
    }
  }

  void adjustDifficulty() {
    double initialDifficulty = _difficulty / 10.0;
    int t = _rights + _wrongs;
    double k = (_wrongs - _rights) / t;
    double changedDifficulty = initialDifficulty / (initialDifficulty + (1 - initialDifficulty) * exp(-k * t));
    double damping = 0.8;
    _adjustedDifficulty = (_difficulty * damping + changedDifficulty * (1 - damping) * 10).round();
  }

  // Getter and setter of _id
  String get id => _id;
  set id(String id) {
    _id = id;
  }

  // Getter and setter of _assessmentID
  String get assessmentID => _assessmentID;
  set assessmentID(String assessmentID) {
    _assessmentID = assessmentID;
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json, String id, String conceptMapID) {
    return QuestionModel.setAll(
      id: id,
      sentence: json['sentence'] as String,
      correctAnswer: json['correctAnswer'] as int,
      choices: List<String>.from(json['choices']),
      relatedConcept: json['relatedConcept'] as String,
      conceptMap: json['conceptMapID'] as String,
      rights: json['rights'] as int,
      wrongs: json['wrongs'] as int,
      assessmentID: json['assessment'] as String,
    );
  }

  // Method to convert an instance of QuestionModelto a map
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'sentence': _sentence,
      'correctAnswer': _correctAnswer,
      'choices': _choices,
      'relatedConcept': _relatedConcept,
      'totalAnswers': _totalAnswers,
      'rights': _rights,
      'wrongs': _wrongs,
      'assessmentID': assessmentID,
      'relatedConceptCount': _relatedConceptCount,
      'testItemRelationships': _testItemRelationships,
      'difficulty': _difficulty,
      'adjustedDifficulty': _adjustedDifficulty,
    };
  }
}
*/
