import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';

class FeedbackService {
  static final _instance = FeedbackService._internal();

  FeedbackService._internal();

  factory FeedbackService() {
    return _instance;
  }

  Future<bool> addFeedbackAndLessons(FeedbackModel feedback) async {
    try {
      List<LessonMaterialModel> materialsAsList = feedback.lessonsAsList();
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("Feedback")
          .withConverter(fromFirestore: (snapshot, _) => FeedbackModel.fromJson(snapshot.data()!, snapshot.id), toFirestore: (model, _) => model.toJson())
          .add(feedback);
      var batch = FirebaseFirestore.instance.batch();
      var lessonsRef = docRef.collection("Materials");
      for (var material in materialsAsList) {
        batch.set(lessonsRef.doc(material.id), material.toJson());
      }
      await batch.commit();
      return true;
    } catch (e) {
      print("Error adding feedback: $e");
    }
    return false;
  }

  Future<bool> updateUserLearningStyle(String userID, String learningStyle) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(userID)
          .update({"learningStyle": learningStyle});
      return true;
    } catch (e) {
      print("Error updating user learning style");
    }
    return false;
  }

  Future<List<FeedbackModel>?> getFeedbackByLearnerID(String userID) async {
    try {
      List<FeedbackModel> feedbackList = [];
      QuerySnapshot rawFeedbacks = await FirebaseFirestore.instance
        .collection("Feedback")
        .withConverter(fromFirestore: (snapshot, _) => FeedbackModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
        .where("userID", isEqualTo: userID).get();
      for (QueryDocumentSnapshot doc in rawFeedbacks.docs) {
        feedbackList.add(doc.data() as FeedbackModel);
      }
      return feedbackList;
    } catch (e) {
      print("Error get feedback: $e");
    }
  }

  Future<List<LessonMaterialModel>?> getFeedbackMaterials(String feedbackID, String lessonID) async {
    try {
      List<LessonMaterialModel> materials = [];
      QuerySnapshot materialsSnapshot = await FirebaseFirestore.instance
          .collection("Feedback")
          .doc(feedbackID)
          .collection("Materials")
          .withConverter(fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(snapshot.data()!, null, lessonID, snapshot.id), toFirestore: (model, _) => model.toJson())
          .get();
      for (var snapshot in materialsSnapshot.docs) {
        materials.add(snapshot.data() as LessonMaterialModel);
      }
      return materials;
    } catch (e) {
      print("Error getting feedback materials: $e");
    }
  }
}