import 'package:flutter/foundation.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/Services/TeacherDashboardService.dart';

class SearchStudentPerformanceViewModel extends ChangeNotifier {
  Future<List<User>>? _students;
  String? studentID;

  Future<List<User>> getStudents() async {
    _students ??= TeacherDashboardService().getAllStudents();
    return _students!;
  }

  void setSelectedStudent(String student) {
    studentID = student;
    notifyListeners();
  }
}
