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
