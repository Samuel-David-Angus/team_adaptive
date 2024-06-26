import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class TeacherLessonService {
  static final _instance = TeacherLessonService._internal();

  TeacherLessonService._internal();

  factory TeacherLessonService() {
    return _instance;
  }

  Future<bool> addLesson(LessonModel lesson) async {
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

  Future<List<LessonModel>> getLessonsByCourse(String courseID) async {
    List<LessonModel> list = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .withConverter(
          fromFirestore: (snapshot, _) => LessonModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        list.add(snapshot.data() as LessonModel);
      }
    } catch(e) {
      print("Error getting lessons: $e");
    }
    return list;
  }

  Future<List<LessonMaterialModel>> getLessonMaterialsByType(String courseID, String lessonID, String type) async {
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
            fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(snapshot.data()!, type, lessonID, snapshot.id),
            toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        list.add(documentSnapshot.data() as LessonMaterialModel);
      }
    } catch (e) {
      print("Error getting lesson materials with type $type: $e");
    }
    return list;
  }

  Future<bool> addLessonMaterial(String courseID, LessonMaterialModel lessonMaterial) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonMaterial.lessonID)
          .collection(lessonMaterial.type!)
          .withConverter(
            fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(snapshot.data()!, lessonMaterial.type!, lessonMaterial.lessonID!, snapshot.id),
            toFirestore: (model, _) => model.toJson())
          .add(lessonMaterial);
      return true;
    } catch(e) {
      print("Error adding lesson material: $e");
    }
    return false;
  }

  Future<bool> editLessonMaterial(String courseID, LessonMaterialModel lessonMaterial) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonMaterial.lessonID)
          .collection(lessonMaterial.type!)
          .withConverter(
          fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(snapshot.data()!, lessonMaterial.type!, lessonMaterial.lessonID!, snapshot.id),
          toFirestore: (model, _) => model.toJson())
          .doc(lessonMaterial.id)
          .set(lessonMaterial);
      return true;
    } catch(e) {
      print("Error adding lesson material: $e");
    }
    return false;
  }

  Future<bool> deleteLessonMaterial(String courseID, LessonMaterialModel lessonMaterial) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonMaterial.lessonID)
          .collection(lessonMaterial.type!)
          .doc(lessonMaterial.id)
          .delete();
      return true;
    } catch(e) {
      print("Error adding lesson material: $e");
    }
    return false;
  }
}