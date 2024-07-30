import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';

class FeedbackModel {
  late AssessmentModel assessment;
  late String userID;
  late List<Map<String, dynamic>> suggestedLessons;
  late String diagnosedLearningStyle;
  Map<String, double>? _lessonConceptFailureRates;
  Map<String, List<String>>? _weakConceptsAndTheirPrereqs;
  int? _skillLevel;

  //assessment must have processAssessment called before passing
  FeedbackModel.setAll({required this.assessment,  required this.userID});

  int getScore() {
    return assessment.score!;
  }

  Map<String, double> calculateLessonConceptFailureRates() {
    if (_lessonConceptFailureRates != null) {
      return _lessonConceptFailureRates!;
    }
    List<String> lessonConcepts = assessment.lesson.concepts!;
    Map<String, double> result = {};
    for (String concept in lessonConcepts) {
      result[concept] = assessment.predictFailureRateOfConcept(concept);
    }
    _lessonConceptFailureRates = result;
    return _lessonConceptFailureRates!;
  }

  Map<String, List<String>> calculateWeakConceptsAndTheirPrereqs() {
    if (_weakConceptsAndTheirPrereqs != null) {
      return _weakConceptsAndTheirPrereqs!;
    }
    Map<String, List<String>> map = {};
    calculateLessonConceptFailureRates().forEach(
        (String concept, double failureRate) {
          if (failureRate <= 50) {
            List<String> prereqs = [];
            assessment.conceptMapModel.findAllPrerequisites(concept, prereqs);
            map[concept] = prereqs;
          }
        }
    );
    _weakConceptsAndTheirPrereqs = map;
    return map;
  }

  List<String> findWeakConcepts() {
    if (_weakConceptsAndTheirPrereqs == null) {
      calculateWeakConceptsAndTheirPrereqs();
    }
    return _weakConceptsAndTheirPrereqs!.keys.toList();
  }

 List<String> determinePrereqsToLearn() {
   if (_weakConceptsAndTheirPrereqs == null) {
     calculateWeakConceptsAndTheirPrereqs();
   }
   List<String> prereqsToLearn = [];
   _weakConceptsAndTheirPrereqs!.forEach(
       (String concept, List<String> prereqs) {
         prereqsToLearn.addAll(prereqs);
       }
   );
   return prereqsToLearn;
 }

 int skillLevel() {
  if (_skillLevel != null) {
    return _skillLevel!;
  }
  _skillLevel = assessment.calculateSkillLevel();
  return _skillLevel!;
 }

 String categorizedSkillLevel() {
  return assessment.categorizeSkillLevel(_skillLevel!);
 }


}