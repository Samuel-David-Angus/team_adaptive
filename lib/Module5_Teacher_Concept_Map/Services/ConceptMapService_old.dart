import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';

class ConceptMapService {
  static final ConceptMapService _instance =  ConceptMapService._internal();

  ConceptMapService._internal();

  factory ConceptMapService() {
    return _instance;
  }

  Future<bool> editConceptMap(ConceptMapModel map) async {
    try {
      await FirebaseFirestore.instance
          .collection('ConceptMap')
          .withConverter(
          fromFirestore: (snapshot, _) => ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(map.courseID)
          .set(map);
      return true;
    } catch (e) {
      debugPrint("Error editing concept map: $e ");
    }
    return false;
  }

  Future<bool> newConceptMap(String courseID) async {
    try {
      ConceptMapModel map = ConceptMapModel.setAll(courseID: courseID, conceptMap: <String, List<int>>{});
      await FirebaseFirestore.instance
          .collection('ConceptMap')
          .withConverter(
            fromFirestore: (snapshot, _) => ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson())
          .doc(courseID)
          .set(map);
      return true;
    } catch (e) {
      debugPrint("Error adding concept map: $e ");
    }
    return false;
  }

  Future<ConceptMapModel?> getConceptMap(String courseID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("ConceptMap")
          .withConverter(
          fromFirestore: (snapshot, _) => ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(courseID)
          .get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as ConceptMapModel;
        return data;


      }

    } catch (e) {
      debugPrint("Error getting concept map: $e");
    }
    return null;
  }
}