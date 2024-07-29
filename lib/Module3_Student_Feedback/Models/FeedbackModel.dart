
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';

class FeedbackModel {
  late AssessmentModel assessment;
  late User user;

  FeedbackModel.setAll({required this.assessment,  required this.user});

  Map<String, double> getLessonConceptFailureRates() {
    List<String> lessonConcepts = assessment.lesson.concepts!;
    Map<String, double> result = {};
    for (String concept in lessonConcepts) {
      result[concept] = assessment.predictFailureRateOfConcept(concept);
    }
    return result;
  }

}