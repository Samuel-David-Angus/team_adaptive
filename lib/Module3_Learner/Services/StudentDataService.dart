import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module3_Learner/Models/StudentDataModel.dart';

class StudentDataService {
  static final _instance = StudentDataService._internal();

  StudentDataService._internal();

  factory StudentDataService() {
    return _instance;
  }

  Future<StudentDataModel?> createStudentData(StudentDataModel studentData) async {
    try {
      // Reference to the collection
      var collectionRef = FirebaseFirestore.instance
          .collection("StudentData")
          .withConverter<StudentDataModel>(
        fromFirestore: (snapshot, _) => StudentDataModel.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (model, _) => model.toJson(),
      );

      // Add the student data
      var docRef = collectionRef.doc(studentData.id);

      await docRef.set(studentData);

      // Retrieve the newly added document
      var docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        debugPrint("Failed to retrieve the newly added document.");
      }
    } catch (e) {
      debugPrint("Error adding student data: $e");
    }
    return null;
  }

  Future<bool> editStudentData(StudentDataModel studentData) async {
    try {
      await FirebaseFirestore.instance
          .collection("StudentData")
          .withConverter(
          fromFirestore: (snapshot, _) => StudentDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(studentData.id)
          .set(studentData);
      return true;
    } catch (e) {
      debugPrint("Error editing student data: $e");
    }
    return false;
  }

  Future<StudentDataModel?> getStudentData(String studentID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("StudentData")
          .withConverter(
          fromFirestore: (snapshot, _) => StudentDataModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(studentID)
          .get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as StudentDataModel;
      }
    } catch (e) {
      debugPrint("Error getting student data: $e");
    }
    return null;
  }
}