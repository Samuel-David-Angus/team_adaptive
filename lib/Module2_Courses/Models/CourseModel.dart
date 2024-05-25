import '../../Module1_User_Management/Models/User.dart';

class Course {
  String? _id;
  String? _title;
  String? _code;
  String? _description;
  List<String>? _students;
  List<String>? _teachers;

  // Constructor
  Course.setAll({required String? id, required String? title, required String? code, required String? description, required List<String>? students, required List<String>? teachers}) {
    _id = id;
    _title = title;
    _code = code;
    _description = description;
    _students = students;
    _teachers = teachers;
  }

  // Getter and Setter for _id
  String? get id => _id;
  set id(String? id) {
    _id = id;
  }

  // Getter and Setter for _title
  String? get title => _title;
  set title(String? title) {
    _title = title;
  }

  // Getter and Setter for _code
  String? get code => _code;
  set code(String? code) {
    _code = code;
  }

  String? get description => _title;
  set description(String? title) {
    _title = title;
  }

  // Getter and Setter for _students
  List<String>? get students => _students;
  set students(List<String>? students) {
    _students = students;
  }

  // Getter and Setter for _teachers
  List<String>? get teachers => _teachers;
  set teachers(List<String>? teachers) {
    _teachers = teachers;
  }

  factory Course.fromJson(Map<String, dynamic> json) => Course.setAll(
    id: json['id'],
    title: json['title'],
    code: json['code'],
    description: json['description'],
    students: List.from(json['students']),
    teachers: List.from(json['teachers'])
  );

  Map<String, Object?> toJson() {
    if (id != null) {
      return {
        'id': id,
        'title': title,
        'code': code,
        'description': description,
        'students': students,
        'teachers': teachers
      };
    }
    return {
      'title': title,
      'code': code,
      'description': description,
      'students': students,
      'teachers': teachers
    };
  }
}