import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

class FeedbackModel {
  late String id;
  late String courseID;
  late String lessonID;
  late String userID;
  late List<Map<String, dynamic>> suggestedLessons;
  late String diagnosedLearningStyle;
  late Map<String, double> lessonConceptFailureRates;
  late Map<String, List<String>> weakConceptsAndTheirPrereqs;
  late int skillLevel;
  late String categorizedSkillLevel;
  late int learnerScore;
  late int assessmentTotal;

  FeedbackModel.setAll({
    required this.id,
    required this.courseID,
    required this.lessonID,
    required this.userID,
    required this.suggestedLessons,
    required this.diagnosedLearningStyle,
    required this.lessonConceptFailureRates,
    required this.weakConceptsAndTheirPrereqs,
    required this.skillLevel,
    required this.categorizedSkillLevel,
    required this.learnerScore,
    required this.assessmentTotal,
  });

  FeedbackModel.createFromAssessment({required AssessmentModel assessment, required this.userID}) {
    courseID = assessment.lesson.courseID!;
    lessonID = assessment.lesson.id!;
    learnerScore = assessment.score!;
    assessmentTotal = assessment.questions.length;
    skillLevel = assessment.calculateSkillLevel();
    categorizedSkillLevel = assessment.categorizeSkillLevel(skillLevel);
    lessonConceptFailureRates = calculateLessonConceptFailureRates(assessment);
    weakConceptsAndTheirPrereqs = calculateWeakConceptsAndTheirPrereqs(assessment);
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json, String id) {
    return FeedbackModel.setAll(
      id: id,
      courseID: json['courseID'],
      lessonID: json['lessonID'],
      userID: json['userID'],
      suggestedLessons: List<Map<String, dynamic>>.from(json["suggestedLessons"]),
      diagnosedLearningStyle: json['diagnosedLearningStyle'],
      lessonConceptFailureRates: Map<String, double>.from(json['lessonConceptFailureRates']),
      weakConceptsAndTheirPrereqs: Map<String, List<String>>.from(
        json['weakConceptsAndTheirPrereqs'].map((key, value) => MapEntry(
          key,
          List<String>.from(value),
        )),
      ),
      skillLevel: json['skillLevel'],
      categorizedSkillLevel: json['categorizedSkillLevel'],
      learnerScore: json['learnerScore'],
      assessmentTotal: json['assessmentTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> modifiedLessonMap = List<Map<String, dynamic>>.from(suggestedLessons);
    for (var map in modifiedLessonMap) {
      map["main"]["lesson"] = map["main"]["lesson"].id;
      map["prereqs"].forEach(
              (item) {
            item["lesson"] = item["lesson"].id;
          }
      );
    }

    return {
      "courseID": courseID,
      "lessonID": lessonID,
      "userID": userID,
      "suggestedLessons": modifiedLessonMap,
      "diagnosedLearningStyle": diagnosedLearningStyle,
      "lessonConceptFailureRates": lessonConceptFailureRates,
      "weakConceptsAndTheirPrereqs": weakConceptsAndTheirPrereqs,
      "skillLevel": skillLevel,
      "categorizedSkillLevel": categorizedSkillLevel,
      "learnerScore": learnerScore,
      "assessmentTotal": assessmentTotal,
    };
  }

  List<LessonMaterialModel> lessonsAsList() {
    List<LessonMaterialModel> materials = [];
    for (var map in suggestedLessons) {
      materials.add(map["main"]["lesson"]);
      map["prereqs"].forEach(
              (item) {
            materials.add(item["lesson"]);
          }
      );
    }
    return materials;
  }

  void setRetrievedMaterials(List<LessonMaterialModel> materials) {
    Map<String, LessonMaterialModel> materialMap = {
      for (var lessonMaterial in materials) lessonMaterial.id!: lessonMaterial
    };
    for (var map in suggestedLessons) {
      map["main"]["lesson"] = materialMap[map["main"]["lesson"]];
      map["prereqs"].forEach(
              (item) {
            item["lesson"] = materialMap[item["lesson"]];
          }
      );
    }
  }

  Map<String, double> calculateLessonConceptFailureRates(AssessmentModel assessment) {
    List<String> lessonConcepts = assessment.lesson.concepts!;
    Map<String, double> result = {};
    for (String concept in lessonConcepts) {
      result[concept] = assessment.predictFailureRateOfConcept(concept);
    }
    return result;
  }

  Map<String, List<String>> calculateWeakConceptsAndTheirPrereqs(AssessmentModel assessment) {
    Map<String, List<String>> map = {};
    lessonConceptFailureRates.forEach((String concept, double failureRate) {
      if (failureRate >= 50) {
        List<String> prereqs =
            assessment.conceptMapModel.findDirectPrerequisites(concept);
        map[concept] = prereqs;
      }
    });
    return map;
  }

  List<String> findWeakConcepts() {
    return weakConceptsAndTheirPrereqs.keys.toList();
  }

  List<String> determinePrereqsToLearn() {
    List<String> prereqsToLearn = [];
    weakConceptsAndTheirPrereqs
        .forEach((String concept, List<String> prereqs) {
      for (var element in prereqs) {
        if (!prereqsToLearn.contains(element)) {
          prereqsToLearn.add(element);
        }
      }
    });
    return prereqsToLearn;
  }

}
