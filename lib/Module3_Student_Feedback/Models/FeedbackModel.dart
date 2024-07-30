
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Services/TeacherLessonService.dart';

class FeedbackModel {
  late AssessmentModel assessment;
  late User user;
  Map<String, double>? _lessonConceptFailureRates;
  List<String>? _weakConcepts;
  List<String>? _prereqsToLearn;


  FeedbackModel.setAll({required this.assessment,  required this.user, required learnerScores}) {
    assessment.processAssessment(learnerScores);
  }

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

  List<String> findWeakConcepts() {
    if (_weakConcepts != null) {
      return _weakConcepts!;
    }
    List<String> weakConcepts = [];
    if (_lessonConceptFailureRates == null) {
      calculateLessonConceptFailureRates();
    }
    _lessonConceptFailureRates!.forEach(
        (String concept, double failureRate) {
          if (failureRate <= 50) {
            weakConcepts.add(concept);
          }
        }
    );
    _weakConcepts = weakConcepts;
    return _weakConcepts!;
  }

 List<String> determinePrereqsToLearn() {
    if (_prereqsToLearn != null) {
      return _prereqsToLearn!;
    }
    List<String> prereqs = [];
    for (String concept in _weakConcepts!){
      assessment.conceptMapModel.findAllPrerequisites(concept, prereqs);
    }
    _prereqsToLearn = prereqs;
    return _prereqsToLearn!;
 }

 List<String> getSuggestedLessons() {
    TeacherLessonService.
 }

 int skillLevel() {
  return assessment.calculateSkillLevel();
 }

 String categorizedSkillLevel() {
  return assessment.categorizeSkillLevel(skillLevel());
 }

 String getLearningStyle() {
    
 }

}