



class AssessmentModel{
  late String _id;
  late String _courseID;
  // late List<String> questions;
  late List<int> _scores;

  // Constructor
  AssessmentModel.setAll({
    required String id,
    required String courseID,
    // required List<String> questions,
    required List<int> scores
    }) {
      _id = id;
      _courseID = courseID;
      _scores = scores;
  }

  // Getter and Setter for _id
  String get id => _id;
  set id(String id) {
    _id = id;
  }

  // Getter and Setter for _lesson
  String get courseID => _courseID;
  set courseID(String courseID) {
    _courseID = courseID;
  }

  // // Getter and Setter for _questions
  // List<String> get questions => _questions;
  // set questions(List<String> questions) {
  //   _questions = questions;
  // }

  // Getter and Setter for _scores
  List<int> get scores => _scores;
  set scores(List<int> scores) {
    _scores = scores;
  }

  factory AssessmentModel.fromJson(Map<String, dynamic> json, String id) {
    return AssessmentModel.setAll(
      id: id,
      courseID: json['courseID'] as String, // Assuming LessonModel has a fromJson method
      // questions: List<String>.from(json['questions']),
      scores: List<int>.from(json['scores'])
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'courseID': courseID,
      // 'questions': questions,
      'scores': scores
    };
  }
}