import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';

class FeedbackModel {
  late String id;
  late String courseID;
  late String lessonID;
  late String userID;
  late String feedbackTitle;
  late DateTime createdDate;
  late String diagnosedLearningStyle;
  late Map<String, double> lessonConceptFailureRates;
  late List<String> weakConcepts;
  late int skillLevel;
  late String categorizedSkillLevel;
  late int learnerScore;
  late int assessmentTotal;

  FeedbackModel.setAll({
    required this.id,
    required this.courseID,
    required this.lessonID,
    required this.userID,
    required this.feedbackTitle,
    required this.createdDate,
    required this.diagnosedLearningStyle,
    required this.lessonConceptFailureRates,
    required this.weakConcepts,
    required this.skillLevel,
    required this.categorizedSkillLevel,
    required this.learnerScore,
    required this.assessmentTotal,
  });

  FeedbackModel.createFromAssessment(
      {required AssessmentModel assessment, required this.userID}) {
    courseID = assessment.lesson.courseID!;
    lessonID = assessment.lesson.id!;
    learnerScore = assessment.score!;
    assessmentTotal = assessment.questions.length;
    skillLevel = assessment.calculateSkillLevel();
    categorizedSkillLevel = assessment.categorizeSkillLevel(skillLevel);
    lessonConceptFailureRates = calculateLessonConceptFailureRates(assessment);
    weakConcepts = findWeakConcepts(assessment);
    createdDate = DateTime.now();
  }

  // factory FeedbackModel.fromJson(Map<String, dynamic> json, String id) {
  //   return FeedbackModel.setAll(
  //     id: id,
  //     courseID: json['courseID'],
  //     lessonID: json['lessonID'],
  //     userID: json['userID'],
  //     feedbackTitle: json['feedbackTitle'],
  //     createdDate: (json['createdDate'] as Timestamp)
  //         .toDate(), //replaced just to remove error
  //     diagnosedLearningStyle: json['diagnosedLearningStyle'],
  //     lessonConceptFailureRates:
  //         Map<String, double>.from(json['lessonConceptFailureRates']),
  //     weakConcepts: List.from(json['weakConcepts']).cast<String>(),
  //     skillLevel: json['skillLevel'],
  //     categorizedSkillLevel: json['categorizedSkillLevel'],
  //     learnerScore: json['learnerScore'],
  //     assessmentTotal: json['assessmentTotal'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "courseID": courseID,
  //     "lessonID": lessonID,
  //     "userID": userID,
  //     "feedbackTitle": feedbackTitle,
  //     "createdDate": Timestamp.fromDate(createdDate),
  //     "diagnosedLearningStyle": diagnosedLearningStyle,
  //     "lessonConceptFailureRates": lessonConceptFailureRates,
  //     "weakConcepts": weakConcepts,
  //     "skillLevel": skillLevel,
  //     "categorizedSkillLevel": categorizedSkillLevel,
  //     "learnerScore": learnerScore,
  //     "assessmentTotal": assessmentTotal,
  //   };
  // }

  Map<String, double> calculateLessonConceptFailureRates(
      AssessmentModel assessment) {
    List<String> lessonConcepts = assessment.lesson.learningOutcomes!;
    Map<String, double> result = {};
    for (String concept in lessonConcepts) {
      result[concept] = assessment.predictFailureRateOfConcept(concept);
    }
    return result;
  }

  List<String> findWeakConcepts(AssessmentModel assessment) {
    List<String> weakConcepts = [];
    lessonConceptFailureRates.forEach((String concept, double failurerate) {
      if (failurerate >
          assessment.conceptMapModel
              .getMaxFailureRateOfLearningOutcome(concept)) {
        weakConcepts.add(concept);
      }
    });
    return weakConcepts;
  }
}
