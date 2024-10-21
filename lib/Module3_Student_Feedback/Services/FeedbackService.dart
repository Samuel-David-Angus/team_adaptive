import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';

class FeedbackService {
  static final _instance = FeedbackService._internal();

  FeedbackService._internal();

  factory FeedbackService() {
    return _instance;
  }

  Future<bool> updateUserLearningStyle(
      String userID, String learningStyle) async {
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

  Future<List<FeedbackSummaryModel>> getUserFeedbackSummaries(
      String userID) async {
    List<FeedbackSummaryModel> feedbacks = [];
    QuerySnapshot<FeedbackSummaryModel> qsnapshot = await FirebaseFirestore
        .instance
        .collection("Feedback")
        .withConverter(
            fromFirestore: (snapshot, _) =>
                FeedbackSummaryModel.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson())
        .where("userID", isEqualTo: userID)
        .get();
    for (var feedbackDoc in qsnapshot.docs) {
      feedbacks.add(feedbackDoc.data());
    }
    return feedbacks;
  }

  Future<FeedbackSummaryModel> getFeedbackSummaryByID(String id) async {
    DocumentSnapshot<FeedbackSummaryModel> dsnapshot = await FirebaseFirestore
        .instance
        .collection("Feedback")
        .withConverter(
            fromFirestore: (snapshot, _) =>
                FeedbackSummaryModel.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson())
        .doc(id)
        .get();
    return dsnapshot.data()!;
  }

  Future<FeedbackSummaryModel> updateFeedbackSummary(
      FeedbackModel feedback) async {
    try {
      CollectionReference<FeedbackSummaryModel> feedbackCollection =
          FirebaseFirestore.instance.collection("Feedback").withConverter(
              fromFirestore: (snapshot, _) =>
                  FeedbackSummaryModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson());
      QuerySnapshot<FeedbackSummaryModel> qsnapshot = await feedbackCollection
          .where("courseID", isEqualTo: feedback.courseID)
          .where("lessonID", isEqualTo: feedback.lessonID)
          .where("userID", isEqualTo: feedback.userID)
          .get();
      if (qsnapshot.docs.isEmpty) {
        DocumentReference docRef = feedbackCollection.doc();
        FeedbackSummaryModel firstFeedback = FeedbackSummaryModel.fromFeedback(
            feedback: feedback, id: docRef.id);
        await docRef.set(firstFeedback);
        return firstFeedback;
      }
      FeedbackSummaryModel feedbackSummary = qsnapshot.docs[0].data();
      feedbackSummary.addFeedback(feedback);
      await feedbackCollection.doc(feedbackSummary.id).set(feedbackSummary);
      return feedbackSummary;
    } catch (e) {
      print("Error updating feedback summary: $e");
      rethrow;
    }
  }

  Future<FeedbackSummaryModel?> getFeedbackFromLearningOutcomeAndUserID(
      String lO, String userID) async {
    try {
      QuerySnapshot<LearningOutcomeModel> qsnapshot = await FirebaseFirestore
          .instance
          .collection("LearningOutcome")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LearningOutcomeModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .where("learningOutcome", isEqualTo: lO)
          .get();
      LearningOutcomeModel lOModel = qsnapshot.docs[0].data();
      QuerySnapshot<FeedbackSummaryModel> feedbackSnapshot =
          await FirebaseFirestore
              .instance
              .collection("Feedback")
              .withConverter(
                  fromFirestore: (snapshot, _) =>
                      FeedbackSummaryModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .where("courseID", isEqualTo: lOModel.courseID)
              .where("lessonID", isEqualTo: lOModel.lessonID)
              .where("userID", isEqualTo: userID)
              .get();
      if (feedbackSnapshot.docs.isEmpty) {
        return null;
      }
      return feedbackSnapshot.docs[0].data();
    } catch (e) {
      print("Error getting learning outcome: $e");
      rethrow;
    }
  }
}
