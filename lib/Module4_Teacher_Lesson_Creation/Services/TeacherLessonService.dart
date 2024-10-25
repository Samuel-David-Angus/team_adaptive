import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class TeacherLessonService {
  static final _instance = TeacherLessonService._internal();

  TeacherLessonService._internal();

  factory TeacherLessonService() {
    return _instance;
  }

  String getLessonID(String courseID) {
    return FirebaseFirestore.instance
        .collection("Course")
        .doc(courseID)
        .collection("Lesson")
        .doc()
        .id;
  }

  Future<bool> confirmSetupComplete(LessonModel lesson) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(lesson.courseID)
          .collection("Lesson")
          .doc(lesson.id)
          .update({"isSetupComplete": true});
      return true;
    } catch (e) {
      debugPrint("Error confirming setup complete: $e");
    }
    return false;
  }

  Future<bool> addLesson(LessonModel lesson) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection("Course")
          .doc(lesson.courseID)
          .collection("Lesson")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  LessonModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson());
      QuerySnapshot querySnapshot = await ref.get();
      lesson.order = querySnapshot.size + 1;
      if (lesson.id == null) {
        await ref.add(lesson);
      } else {
        print(lesson.id);
        await ref.doc(lesson.id!).set(lesson);
      }
      return true;
    } catch (e) {
      debugPrint("Error adding lesson: $e");
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
    } catch (e) {
      debugPrint("Error getting lesson materials with type $type: $e");
    }
    return list;
  }

  Future<bool> addLessonMaterial(
      String courseID, LessonMaterialModel lessonMaterial) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonMaterial.lessonID)
          .collection(lessonMaterial.type!)
          .withConverter(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, lessonMaterial.type!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .add(lessonMaterial);
      return true;
    } catch (e) {
      debugPrint("Error adding lesson material: $e");
    }
    return false;
  }

  Future<bool> addMultipleLessonMaterials(String courseID, String lessonID,
      List<LessonMaterialModel> materials) async {
    try {
      List<DocumentReference> docRefs = [];
      List<Future<String>> materialURLs = [];
      DocumentReference parentRef = FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonID);
      for (LessonMaterialModel material in materials) {
        docRefs.add(parentRef.collection(material.type!).doc());
      }
      for (int i = 0; i < materials.length; i++) {
        if (materials[i].src == null) {
          String filename =
              "${materials[i].courseID!}/${materials[i].lessonID!}/${docRefs[i].id}";
          Reference storageRef =
              FirebaseStorage.instance.ref().child('materials/$filename');
          Future<String> uploadTask = storageRef
              .putData(
                  materials[i].fileBytes!,
                  SettableMetadata(
                      contentType: getMimeType(
                          materials[i].fileName!))) // Upload the file
              .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
          materialURLs.add(uploadTask);
        } else {
          materialURLs.add(Future.value(materials[i].src!));
        }
      }
      List<String> finalURLS = await Future.wait<String>(materialURLs);
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (int j = 0; j < materials.length; j++) {
        var material = materials[j];
        material.src = finalURLS[j];
        DocumentReference ref = parentRef.collection(material.type!).doc();
        batch.set(ref, material.toJson());
      }
      await batch.commit();
      return true;
    } catch (e) {
      debugPrint('Error adding multiple materials: $e');
    }
    return false;
  }

  Future<bool> editLessonMaterial(
      String courseID, LessonMaterialModel lessonMaterial) async {
    try {
      await FirebaseFirestore.instance
          .collection("Course")
          .doc(courseID)
          .collection("Lesson")
          .doc(lessonMaterial.lessonID)
          .collection(lessonMaterial.type!)
          .withConverter(
              fromFirestore: (snapshot, _) => LessonMaterialModel.fromJson(
                  snapshot.data()!, lessonMaterial.type!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .doc(lessonMaterial.id)
          .set(lessonMaterial);
      return true;
    } catch (e) {
      debugPrint("Error adding lesson material: $e");
    }
    return false;
  }

  Future<bool> deleteLessonMaterial(
      String courseID, LessonMaterialModel lessonMaterial) async {
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
    } catch (e) {
      debugPrint("Error adding lesson material: $e");
    }
    return false;
  }

  String getMimeType(String path) {
    // Map of file extensions to MIME types
    final Map<String, String> mimeTypes = {
      'pdf': 'application/pdf',
      'mp4': 'video/mp4',
      'm4v': 'video/x-m4v',
      'avi': 'video/x-msvideo',
      'mov': 'video/quicktime',
      'wmv': 'video/x-ms-wmv',
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'aac': 'audio/aac',
      'ogg': 'audio/ogg',
      'flac': 'audio/flac',
      // Add more audio and video types as needed
    };

    // Extract the file extension
    final String extension = path.split('.').last.toLowerCase();

    // Return the corresponding MIME type, or a default type
    return mimeTypes[extension]!; // Default MIME type
  }
}
