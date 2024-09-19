

import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';

import '../../Module1_User_Management/Services/AuthServices.dart';
import '../Models/CourseModel.dart';
import '../Services/TeacherCourseServices.dart';

class TeacherCourseViewModel extends ChangeNotifier{
  TeacherCourseServices courseService = TeacherCourseServices();


  Future<List<Course>?> getCourses() async {
    if (AuthServices().userInfo != null) {
      return await courseService.getCourses(AuthServices().userInfo!);
    }
    return null;
  }

  Future<Course?> addCourse(Course course) async {
    return await courseService.addCourse(course);
  }

  Future<bool> joinCourse(String courseID) async {
    return await courseService.joinCourse(courseID, AuthServices().userInfo!);
  }

  bool validate(String title, String code, String description, ConceptMapModel conceptMapModel) {
    return title.isNotEmpty && code.isNotEmpty && description.isNotEmpty && conceptMapModel.conceptCount > 0;
  }

}