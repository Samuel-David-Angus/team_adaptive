import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import '../../Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class StudentLessonService {
  static final _instance = StudentLessonService._internal();

  StudentLessonService._internal();

  factory StudentLessonService() {
    return _instance;
  }

  Future<LessonModel?> getLessonByID(String courseID, String lessonID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LessonModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .doc(lessonID)
          .get();
      return documentSnapshot.data() as LessonModel;
    } catch (e) {
      debugPrint("Error getting lesson: $e");
    }
    return null;
  }

  Future<List<LessonModel>> getLessonsByCourse(String courseID) async {
    List<LessonModel> list = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LessonModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        list.add(snapshot.data() as LessonModel);
      }
    } catch (e) {
      debugPrint("Error getting lessons: $e");
    }
    return list;
  }

  Future<List<LessonMaterialModel>> getLessonMaterialsByTypeAndStyle(
      String courseID, String lessonID, String type, String style) async {
    List<LessonMaterialModel> list = [];
    try {
      assert(type == "main" || type == "sub");
      QuerySnapshot<LessonMaterialModel> querySnapshot = await FirebaseFirestore
          .instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonID)
          .collection(type)
          .where("learningStyle", isEqualTo: style)
          .withConverter<LessonMaterialModel>(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, type, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot<LessonMaterialModel> documentSnapshot
          in querySnapshot.docs) {
        list.add(documentSnapshot.data() as LessonMaterialModel);
      }
    } catch (e) {
      debugPrint("Error getting lesson materials with type $type: $e");
    }
    return list;
  }

  Future<List<LessonMaterialModel>> getLessonMaterialsByType(
      String courseID, String lessonID, String type) async {
    List<LessonMaterialModel> list = [];
    try {
      assert(type == "main" || type == "sub");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonID)
          .collection(type)
          .withConverter(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, type, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        list.add(documentSnapshot.data() as LessonMaterialModel);
      }
      debugPrint('got materials');
    } catch (e) {
      debugPrint("Error getting lesson materials with type $type: $e");
    }
    return list;
  }

  Future<LessonMaterialModel?> getLessonMaterialByTypeAndID(
      {required String courseID,
      required String lessonID,
      required String type,
      required String materialID}) async {
    try {
      assert(type == "main" || type == "sub");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonID)
          .collection(type)
          .withConverter(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, type, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .doc(materialID)
          .get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as LessonMaterialModel;
      }
    } catch (e) {
      debugPrint("Error getting material by id: $e");
    }
    return null;
  }

  Future<List<LessonMaterialModel>?> findSubMaterialsByLO(String lO) async {
    try {
      List<LessonMaterialModel> materials = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collectionGroup("sub")
          .where("concepts", arrayContains: lO)
          .withConverter(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, "sub", snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot documentSnapshot in snapshot.docs) {
        materials.add(documentSnapshot as LessonMaterialModel);
      }
      return materials;
    } catch (e) {
      print("Error getting sub materials: $e");
    }
    return null;
  }
}
