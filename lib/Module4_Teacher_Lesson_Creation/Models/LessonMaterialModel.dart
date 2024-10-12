class LessonMaterialModel {
  String? _id;
  String? _title;
  String? _author;
  String? _type;
  String? _courseID;
  String? _lessonID;
  String? _src;
  String? _learningStyle;
  List<String>? _concepts;

  // Constructor
  LessonMaterialModel.setAll({
    required String id,
    required String title,
    required String author,
    required String? type,
    required String? lessonID,
    required String? courseID,
    required String src,
    required String learningStyle,
    required List<String> concepts,
  })  : _id = id,
        _title = title,
        _author = author,
        _type = type,
        _lessonID = lessonID,
        _courseID = courseID,
        _src = src,
        _learningStyle = learningStyle,
        _concepts = concepts;

  LessonMaterialModel();

  // Getters
  String? get id => _id;
  String? get title => _title;
  String? get author => _author;
  String? get type => _type;
  String? get lessonID => _lessonID;
  String? get courseID => _courseID;
  String? get src => _src;
  String? get learningStyle => _learningStyle;
  List<String>? get concepts => _concepts;

  // Setters
  set id(String? id) {
    _id = id;
  }

  set title(String? title) {
    _title = title;
  }

  set author(String? value) {
    _author = value;
  }

  set type(String? value) {
    _type = value;
  }

  set lessonID(String? value) {
    _lessonID = value;
  }

  set courseID(String? value) {
    _courseID = value;
  }

  set src(String? value) {
    _src = value;
  }

  set learningStyle(String? value) {
    _learningStyle = value;
  }

  set concepts(List<String>? value) {
    _concepts = value;
  }

  // fromJson factory method
  factory LessonMaterialModel.fromJson(
      Map<String, dynamic> json, String? type, String id) {
    return LessonMaterialModel.setAll(
      id: id,
      title: json['title'],
      author: json['author'],
      type: type,
      lessonID: json['lessonID'],
      courseID: json['courseID'],
      src: json['src'],
      learningStyle: json['learningStyle'],
      concepts: List<String>.from(json['concepts']),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'title': _title,
      'author': _author,
      'lessonID': _lessonID,
      'courseID': _courseID,
      'src': _src,
      'learningStyle': _learningStyle,
      'concepts': _concepts,
    };
  }
}
