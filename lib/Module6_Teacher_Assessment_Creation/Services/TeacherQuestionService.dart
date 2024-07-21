/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';

class TeacherQuestionService {
  static final TeacherQuestionService _instance = TeacherQuestionService._internal();
  
  TeacherQuestionService._internal();

  factory TeacherQuestionService() {
    return _instance;
  }

  Future<bool> addQuestion(QuestionModel question, String courseID, String assessmentID) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection("Question")
          .withConverter(
            fromFirestore: (snapshot, _) => QuestionModel.fromJson(snapshot.data()!, snapshot.id, assessmentID, conceptMap.id),
            toFirestore: (model, _) => model.toJson());
      await ref.add(question);
      return true;
    } catch (e) {
      print("Error adding lesson: $e");
    }
    return false;
  }

  Future<bool> editQuestion(QuestionModel question, ConceptMapModel conceptMap, String courseID, String assessmentID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Question")
          .withConverter(
          fromFirestore: (snapshot, _) => ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(question.id);
      return true;
    } catch (e) {
      print("Error editing concept map: $e ");
    }
    return false;
  }
}*/
