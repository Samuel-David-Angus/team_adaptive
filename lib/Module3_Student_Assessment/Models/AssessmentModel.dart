import 'dart:math';

import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';

class AssessmentModel {
  late LessonModel _lesson;
  late List<QuestionModel> _questions;
  late ConceptMapModel _conceptMapModel;
  late List<int> _scores;

  late List<Map<String, dynamic>> processedQuestions;
  late List<int> _answers;
  int? score;

  // Constructor
  AssessmentModel.createNew({
    required LessonModel lessonID,
    required List<QuestionModel> questions,
    required ConceptMapModel conceptMapModel
    }) :  _lesson = lessonID,
          _questions = questions,
          _conceptMapModel = conceptMapModel,
          _scores = List.filled(questions.length, 0)
  {
    generateProcessedQuestions();
  }


  // Getter for _lessonID
  LessonModel get lesson => _lesson;

  // Setter for _lessonID
  set lessonID(LessonModel value) {
    _lesson = value;
  }

  // Getter for _questions
  List<QuestionModel> get questions => _questions;

  // Setter for _questions
  set questions(List<QuestionModel> value) {
    _questions = value;
  }

  // Getter for _conceptMapModel
  ConceptMapModel get conceptMapModel => _conceptMapModel;

  // Setter for _conceptMapModel
  set conceptMapModel(ConceptMapModel value) {
    _conceptMapModel = value;
  }

  // Getter for _scores
  List<int> get scores => _scores;

  // Setter for _scores
  set scores(List<int> value) {
    _scores = value;
  }

  List<Map<String, dynamic>> generateProcessedQuestions() {
    List<Map<String, dynamic>> processedQuestions = [];
    _answers = [];
    for (var question in _questions) {
          var rng = Random();
          int correctChoice = rng.nextInt(question.wrongChoices.length + 1);
          List<String> choices = question.wrongChoices;
          choices.shuffle();
          choices.insert(correctChoice, question.correctAnswer);
          _answers.add(correctChoice);
          processedQuestions.add(
            {
              "question": question.question,
              "choices": choices,
            }
          );
        }
    this.processedQuestions = processedQuestions;
    return processedQuestions;
  }

  int processAssessment(List<int> studentAnswers) {
    assert(studentAnswers.length == _answers.length, "the answer arrays must have the same length");
    int overallScore = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (studentAnswers[i] == _answers[i]) {
        _scores[i] = 1;
        overallScore++;
      } else {
        _scores[i] = 0;
      }
    }
    score = overallScore;
    return overallScore;
  }


  List<int> calculateTestItemRelationships(QuestionModel question) {
    String questionConcept = question.questionConcept;
    int questionConceptDepth = conceptMapModel.findConceptDepth(
        questionConcept);
    int conceptCount = conceptMapModel.conceptCount;

    // Initialize the list with zeros
    List<int> testItemRelationships = List<int>.filled(conceptCount, 0);
    List<String> relatedConcepts = question.findAllPrerequisites(conceptMapModel);

    for (int index = 0; index < conceptCount; index++) {
      String concept = conceptMapModel.conceptOfIndex(index);
      if (relatedConcepts.contains(concept)) {
        int conceptDepth = conceptMapModel.findConceptDepth(concept);
        int relatedness = (5 * conceptDepth) ~/
            questionConceptDepth; // Use integer division
        testItemRelationships[index] = relatedness;
      }
    }
    return testItemRelationships;
  }

  List<int> calculateTotalConceptStrengths() {
    int conceptCount = conceptMapModel.conceptCount;

    // Initialize the list with zeros
    List<int> totalConceptStrengths = List<int>.filled(conceptCount, 0);
    int questionCount = _questions.length;

    for (int questionIndex = 0; questionIndex < questionCount; questionIndex++) {
      QuestionModel questionModel = _questions[questionIndex];

      for (int conceptIndex = 0; conceptIndex < conceptCount; conceptIndex++) {
        List<int> testItemRelationships = calculateTestItemRelationships(questionModel);
        int conceptStrength = totalConceptStrengths[conceptIndex];
        int addedConceptStrength = conceptStrength + testItemRelationships[conceptIndex];
        totalConceptStrengths[conceptIndex] = addedConceptStrength;
      }
    }

    return totalConceptStrengths;
  }

  double predictFailureRateOfConcept(String concept) {
    int weightedSum = 0;
    int conceptIndex = conceptMapModel.indexOfConcept(concept);
    List<int> totalConceptStrengths = calculateTotalConceptStrengths();
    int questionCount = _questions.length;

    for (int index = 0; index < questionCount; index++) {
      QuestionModel question = _questions[index];
      List<int> testItemRelationships = calculateTestItemRelationships(question);
      weightedSum += (1 - _scores[index]) * testItemRelationships[conceptIndex];
    }

    return 100.0 * weightedSum / totalConceptStrengths[conceptIndex];
  }

  int calculateSkillLevel() {
    int sum = 0;
    int questionCount = _questions.length;

    for (int index = 0; index < questionCount; index++) {
      if (_scores[index] == 1) {
        QuestionModel question = _questions[index];
        sum += question.adjustedDifficulty;
      }
    }

    return sum ~/ questionCount; // Use integer division
  }

  String categorizeSkillLevel(int skillLevel) {
    if (skillLevel < 4) {
      return "Beginner";
    } else if (skillLevel < 8) {
      return "Intermediate";
    } else {
      return "Expert";
    }
  }

  void adjustQuestionDifficulties() {
    for (int i = 0; i < _questions.length; i++) {
      if (_scores[i] == 1) {
        questions[i].numberOfCorrectAnswers++;
      } else {
        questions[i].numberOfWrongAnswers++;
      }
      questions[i].calculateAdjustedDifficulty(conceptMapModel);
    }
  }
}