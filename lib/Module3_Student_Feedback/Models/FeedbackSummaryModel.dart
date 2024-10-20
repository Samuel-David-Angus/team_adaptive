import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';

class FeedbackSummaryModel {
  final String id;
  final String courseID;
  final String lessonID;
  final String userID;
  final String title;
  final Map<String, List<double>>
      lOsAndRateHistory; // Learning Outcomes and Rate History
  final List<int> skillLvlHistory;
  final List<String> learningStyleHistory;
  final Map<int, List<String>> weakConceptsHistory;
  final List<int> scoreHistory;
  final List<Timestamp> dateHistory;
  final int assessmentTotal;

  int get mostRecentSkillLevel => skillLvlHistory.last;
  String get mostRecentLearningStyle => learningStyleHistory.last;
  List<String> get mostRecentWeakConcepts =>
      weakConceptsHistory[weakConceptsHistory.length - 1]!;
  String get mostRecentCategorizedSkillLevel =>
      categorizeSkillLevel(mostRecentSkillLevel);
  int get mostRecentScore => scoreHistory.last;
  Timestamp get mostRecentDate => dateHistory.last;
  Map<String, double> get mostRecentLOsAndRates =>
      lOsAndRateHistory.map((String lO, List<double> rateHistory) {
        return MapEntry(lO, rateHistory.last);
      });

  // Constructor
  FeedbackSummaryModel.setAll(
      {required this.id,
      required this.courseID,
      required this.lessonID,
      required this.userID,
      required this.title,
      required this.lOsAndRateHistory,
      required this.skillLvlHistory,
      required this.learningStyleHistory,
      required this.weakConceptsHistory,
      required this.scoreHistory,
      required this.dateHistory,
      required this.assessmentTotal});

  factory FeedbackSummaryModel.fromJson(Map<String, dynamic> map) {
    return FeedbackSummaryModel.setAll(
        id: map['id'],
        courseID: map['courseID'],
        lessonID: map['lessonID'],
        userID: map['userID'],
        title: map['title'],
        lOsAndRateHistory: Map<String, List<double>>.from(
          map['lOsAndRateHistory']
              ?.map((key, value) => MapEntry(key, List<double>.from(value))),
        ),
        skillLvlHistory: List<int>.from(map['skillLvlHistory']),
        learningStyleHistory: List<String>.from(map['learningStyleHistory']),
        weakConceptsHistory: Map<int, List<String>>.from(
            map['weakConceptsHistory']?.map((key, value) =>
                MapEntry(int.parse(key), List<String>.from(value)))),
        scoreHistory: List<int>.from(map['scoreHistory']),
        dateHistory: List<Timestamp>.from(map['dateHistory']),
        assessmentTotal: map['assessmentTotal']);
  }

  factory FeedbackSummaryModel.fromFeedback(
      {required FeedbackModel feedback, required String id}) {
    FeedbackSummaryModel emptyFeedbackSummary = FeedbackSummaryModel.setAll(
        id: id,
        courseID: feedback.courseID,
        lessonID: feedback.lessonID,
        userID: feedback.userID,
        title: feedback.feedbackTitle,
        lOsAndRateHistory: {},
        skillLvlHistory: [],
        learningStyleHistory: [],
        weakConceptsHistory: {},
        scoreHistory: [],
        dateHistory: [],
        assessmentTotal: feedback.assessmentTotal);
    emptyFeedbackSummary.addFeedback(feedback);
    return emptyFeedbackSummary;
  }

  // Method to convert the object to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseID': courseID,
      'lessonID': lessonID,
      'userID': userID,
      'title': title,
      'lOsAndRateHistory':
          lOsAndRateHistory.map((key, value) => MapEntry(key, value)),
      'skillLvlHistory': skillLvlHistory,
      'learningStyleHistory': learningStyleHistory,
      'weakConceptsHistory': weakConceptsHistory
          .map((key, value) => MapEntry(key.toString(), value)),
      'scoreHistory': scoreHistory,
      'dateHistory': dateHistory,
      'assessmentTotal': assessmentTotal
    };
  }

  void addFeedback(FeedbackModel feedback) {
    dateHistory.add(Timestamp.fromDate(feedback.createdDate));
    learningStyleHistory.add(feedback.diagnosedLearningStyle);
    skillLvlHistory.add(feedback.skillLevel);
    weakConceptsHistory[weakConceptsHistory.length] = feedback.weakConcepts;
    scoreHistory.add(feedback.learnerScore);
    feedback.lessonConceptFailureRates.forEach((String lO, double failrate) {
      if (!lOsAndRateHistory.containsKey(lO)) {
        lOsAndRateHistory[lO] = [];
      }
      lOsAndRateHistory[lO]!.add(failrate);
    });
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

  FeedbackModel getFeedbackFromIndex(int index) {
    return FeedbackModel.setAll(
        id: index.toString(),
        courseID: courseID,
        lessonID: lessonID,
        userID: userID,
        feedbackTitle: title,
        createdDate: dateHistory[index].toDate(),
        diagnosedLearningStyle: learningStyleHistory[index],
        lessonConceptFailureRates: getLOsAndRateByIndex(index),
        weakConcepts: weakConceptsHistory[index]!,
        skillLevel: skillLvlHistory[index],
        categorizedSkillLevel: categorizeSkillLevel(skillLvlHistory[index]),
        learnerScore: scoreHistory[index],
        assessmentTotal: assessmentTotal);
  }

  Map<String, double> getLOsAndRateByIndex(int index) {
    return lOsAndRateHistory.map((String lO, List<double> rates) {
      return MapEntry(lO, rates[index]);
    });
  }

  String learningStatusBasedOnLORate(double rate) {
    if (rate <= 25) {
      return "Very Poorly Learned";
    } else if (rate <= 0.5) {
      return "Less Poorly Learned";
    } else if (rate <= 0.75) {
      return "Learned";
    } else {
      return "Very Poorly Learned";
    }
  }
}
