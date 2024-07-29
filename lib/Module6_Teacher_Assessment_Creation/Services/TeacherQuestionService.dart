
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/QuestionModel.dart';

class TeacherQuestionService {
  static final TeacherQuestionService _instance = TeacherQuestionService._internal();

  TeacherQuestionService._internal();

  factory TeacherQuestionService() {
    return _instance;
  }

  Future<bool> addQuestion(QuestionModel question, String lessonID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Question")
          .doc(lessonID)
          .collection("Pool")
          .withConverter(
          fromFirestore: (snapshot, _) => QuestionModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => question.toJson())
          .add(question);
      return true;
    } catch (e) {
      print("Error adding questions: $e");
    }
    return false;
  }

  Future<bool> deleteQuestion(QuestionModel question, String lessonID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Question")
          .doc(lessonID)
          .collection("Pool")
          .doc(question.id)
          .delete();
      return true;
    } catch (e) {
      print("Error deleting question: $e");
    }
    return false;
  }

  Future<bool> editQuestion(QuestionModel question, String lessonID) async {
    try {
      await FirebaseFirestore.instance
          .collection("Question")
          .doc(lessonID)
          .collection("Pool")
          .withConverter(
          fromFirestore: (snapshot, _) => QuestionModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => question.toJson())
          .doc(question.id)
          .set(question);
      return true;
    } catch (e) {
      print("Error editing concept map: $e ");
    }
    return false;
  }

  Future<List<QuestionModel>?> getLessonQuestions(String lessonID) async {
    List<QuestionModel> questions = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Question")
          .doc(lessonID)
          .collection("Pool")
          .withConverter(
          fromFirestore: (snapshot, _) => QuestionModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => {})
          .get();
      querySnapshot.docs.forEach(
          (QueryDocumentSnapshot docSnapshot) {
            questions.add(docSnapshot.data() as QuestionModel);
          }
      );
      return questions;
    } catch (e) {
      print("Error getting questions: $e");
    }
    return null;
  }
}

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
