class LearningOutcomeModel {
  late final String id;
  late final String courseID;
  late final String lessonID;
  late final String learningOutcome;
  late final List<String> directPrereqs;

  // Constructor to set all fields
  LearningOutcomeModel.setAll({
    required this.id,
    required this.courseID,
    required this.lessonID,
    required this.learningOutcome,
    required this.directPrereqs,
  });

  factory LearningOutcomeModel.fromJson(Map<String, dynamic> json, String id) {
    return LearningOutcomeModel.setAll(
      id: id,
      courseID: json['courseID'],
      lessonID: json['lessonID'],
      learningOutcome: json['concept'],
      directPrereqs: List<String>.from(json['directPrereqs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseID': courseID,
      'lessonID': lessonID,
      'learningOutcome': learningOutcome,
      'directPrereqs': directPrereqs,
    };
  }
}
