import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';

class TeacherDashboardService {
  static final TeacherDashboardService _instance =
      TeacherDashboardService._internal();
  TeacherDashboardService._internal();
  factory TeacherDashboardService() {
    return _instance;
  }
  Future<List<User>> getAllStudents() async {
    List<User> users = [];
    try {
      QuerySnapshot<User> querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("type", isEqualTo: "student")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  User.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot<User> documentSnapshot in querySnapshot.docs) {
        users.add(documentSnapshot.data()!);
      }
    } catch (e) {
      print("Error getting student users: $e");
      rethrow;
    }
    return users;
  }

  Future<List<FeedbackSummaryModel>> getFeedbackSummariesByLessonAndCourse(
      String courseID, String lessonID) async {
    List<FeedbackSummaryModel> feedbackSummaries = [];
    try {
      QuerySnapshot<FeedbackSummaryModel> querySnapshot =
          await FirebaseFirestore.instance
              .collection("Feedback")
              .withConverter(
                  fromFirestore: (snapshot, _) =>
                      FeedbackSummaryModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .where("courseID", isEqualTo: courseID)
              .where("lessonID", isEqualTo: lessonID)
              .get();
      for (DocumentSnapshot<FeedbackSummaryModel> documentSnapshot
          in querySnapshot.docs) {
        feedbackSummaries.add(documentSnapshot.data()!);
      }
      return feedbackSummaries;
    } catch (e) {
      print("Error getting feedbacks for this course and lesson: $e");
      rethrow;
    }
  }
}
