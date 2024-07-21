import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
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
      print("Error editing concept map: $e ");
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
      print("Error adding lesson: $e");
    }
    return false;
  }
*/
  Future<bool> uploadConceptMap(String courseID, ConceptMapModel conceptMap) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection('Course')
          .doc(courseID)
          .collection("ConceptMap")
          .withConverter(
            fromFirestore: (snapshot, _) => ConceptMapModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson());
          QuerySnapshot querySnapshot = await ref.get();
          await ref.add(conceptMap);
      return true;
    } catch (e) {
      print("Error adding concept map: $e ");
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
      print("Error getting concept map: $e");
    }
    return null;
  }
}