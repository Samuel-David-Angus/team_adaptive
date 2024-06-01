class LessonModel {
  String? _id;
  String? _lessonTitle;
  String? _lessonDescription;
  String? _courseID;
  List<String>? _concepts;
  int? _order;

  // Constructor
  LessonModel.setAll({
    required String id,
    required String lessonTitle,
    required String lessonDescription,
    required String courseID,
    required List<String> concepts,
    required int order
  })  : _id = id,
        _lessonTitle = lessonTitle,
        _lessonDescription = lessonDescription,
        _courseID = courseID,
        _concepts = concepts,
        _order = order;

  LessonModel();

  // Getters
  String? get id => _id;
  String? get lessonTitle => _lessonTitle;
  String? get lessonDescription => _lessonDescription;
  String? get courseID => _courseID;
  List<String>? get concepts => _concepts;
  int? get order => _order;

  // Setters
  set id(String? id) {
    _id = id;
  }

  set lessonTitle(String? lessonTitle) {
    _lessonTitle = lessonTitle;
  }

  set lessonDescription(String? lessonDescription) {
    _lessonDescription = lessonDescription;
  }

  set courseID(String? courseID) {
    _courseID = courseID;
  }

  set concepts(List<String>? concepts) {
    _concepts = concepts;
  }

  set order(int? order) {
    _order = order;
  }


  factory LessonModel.fromJson(Map<String, dynamic> json, String id) {
    print(json);
    return LessonModel.setAll(
      id: id,
      lessonTitle: json['lessonTitle'] as String,
      lessonDescription: json['lessonDescription'] as String,
      courseID: json['courseID'] as String,
      concepts: List<String>.from(json['concepts']),
      order: json['order'],
    );
  }

  // Method to convert an instance of LessonModel to a map
  Map<String, dynamic> toJson() {
    return {
      'lessonTitle': _lessonTitle,
      'lessonDescription': _lessonDescription,
      'courseID': _courseID,
      'concepts': _concepts,
      'order': _order,
    };
  }
}