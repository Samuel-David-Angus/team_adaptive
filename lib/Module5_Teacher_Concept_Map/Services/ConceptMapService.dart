import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';

class ConceptMapService {
  static final ConceptMapService _instance = ConceptMapService._internal();

  ConceptMapService._internal();

  factory ConceptMapService() {
    return _instance;
  }

  Future<bool> editConceptMapAndAddNewLOs(
      ConceptMapModel map, String lessonID) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var lO in map.lessonPartitions[lessonID]!) {
        DocumentReference doc =
            FirebaseFirestore.instance.collection("LearningOutcome").doc();
        LearningOutcomeModel model = LearningOutcomeModel.setAll(
            id: doc.id,
            courseID: map.courseID!,
            lessonID: lessonID,
            learningOutcome: lO,
            directPrereqs: map.findDirectPrerequisites(lO));
        batch.set(doc, model.toJson());
      }

      DocumentReference cmap = FirebaseFirestore.instance
          .collection('Course')
          .doc(map.courseID)
          .collection('ConceptMap')
          .doc(map.id);
      batch.set(cmap, map.toJson());

      await batch.commit();

      return true;
    } catch (e) {
      debugPrint("Error editing concept map: $e ");
    }
    return false;
  }

/*  Future<bool> addLesson(LessonModel lesson) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection("Course")
          .doc(lesson.courseID)
          .collection("Lesson")
          .withConverter(
          fromFirestore: (snapshot, _) => LessonModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson());
      QuerySnapshot querySnapshot = await ref.get();
      lesson.order = querySnapshot.size + 1;
      await ref.add(lesson);
      return true;
    } catch (e) {
      debugPrint("Error adding lesson: $e");
    }
    return false;
  }
*/
  Future<bool> uploadConceptMap(
      String courseID, ConceptMapModel conceptMap) async {
    try {
      conceptMap.courseID = courseID;
      var ref = FirebaseFirestore.instance
          .collection('Course')
          .doc(courseID)
          .collection("ConceptMap")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson());
      await ref.add(conceptMap);
      return true;
    } catch (e) {
      debugPrint("Error adding concept map: $e ");
    }
    return false;
  }

  Future<ConceptMapModel?> getConceptMap(String courseID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("ConceptMap")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      return querySnapshot.docs[0].data() as ConceptMapModel;
    } catch (e) {
      debugPrint("Error getting concept map: $e");
    }
    return null;
  }

  Future<List<LearningOutcomeModel>?> getExternalLearningOutcomes(
      String lessonID) async {
    try {
      List<LearningOutcomeModel> lOs = [];
      QuerySnapshot list = await FirebaseFirestore.instance
          .collection("LearningOutcome")
          .where("lessonID", isNotEqualTo: lessonID)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LearningOutcomeModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot doc in list.docs) {
        lOs.add(doc.data() as LearningOutcomeModel);
      }
      return lOs;
    } catch (e) {
      print("Error getting learning outcomes");
    }
  }

  Future<List<LearningOutcomeModel>?> getAllLearningOutcomes() async {
    try {
      List<LearningOutcomeModel> lOs = [];
      QuerySnapshot list = await FirebaseFirestore.instance
          .collection("LearningOutcome")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LearningOutcomeModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot doc in list.docs) {
        lOs.add(doc.data() as LearningOutcomeModel);
      }
      return lOs;
    } catch (e) {
      print("Error getting learning outcomes: $e");
    }
  }

  Future<LearningOutcomeModel?> getLearningOutcome(String lO) async {
    try {
      QuerySnapshot qsnapshot = await FirebaseFirestore.instance
          .collection("LearningOutcome")
          .where("learningOutcome", isEqualTo: lO)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LearningOutcomeModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      return qsnapshot.docs[0].data() as LearningOutcomeModel;
    } catch (e) {
      print("Error getting learning outcome: $e");
    }
  }
}
