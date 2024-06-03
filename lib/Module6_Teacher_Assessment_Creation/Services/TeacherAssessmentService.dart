import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/AssessmentModel.dart';

class TeacherAssessmentService {
  static final TeacherAssessmentService _instance = TeacherAssessmentService._internal();
  
  TeacherAssessmentService._internal();

  factory TeacherAssessmentService() {
    return _instance;
  }

  static Future<bool> createAssessment(AssessmentModel assessment, String courseID, String lessonID) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection("Assessment")
          .withConverter(
            fromFirestore: (snapshot, _) => AssessmentModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson());
      await ref.add(assessment);
      return true;
    } catch (e) {
      print("Error adding lesson: $e");
    }
    return false;
  }

  static Future<AssessmentModel?> getAssessment(String assessmentID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Assessment")
          .withConverter(
          fromFirestore: (snapshot, _) => AssessmentModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(assessmentID)
          .get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as AssessmentModel;
        return data;
      }

    } catch (e) {
      print("Error getting concept map: $e");
    }
    return null;
  }
}