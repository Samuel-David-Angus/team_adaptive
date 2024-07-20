class StudentDataModel {
  String? _id;
  String? _currentLearningStyle;
  Map<String, String>? _learningStyleHistory;
  int? _overallLevel;
  Map<String, int>? _levelHistory;
  Map<String, String>? _currentLessons;

  // Constructor
  StudentDataModel.setAll({
    String? id,
    String? currentLearningStyle,
    Map<String, String>? learningStyleHistory,
    int? overallLevel,
    Map<String, int>? levelHistory,
    Map<String, String>? currentLessons
  })  : _id = id,
        _currentLearningStyle = currentLearningStyle,
        _learningStyleHistory = learningStyleHistory,
        _overallLevel = overallLevel,
        _levelHistory = levelHistory,
        _currentLessons = currentLessons;

  StudentDataModel.basic(String id) {
    _id = id;
    _currentLearningStyle = "Text";
  }

  // Getters
  String? get id => _id;
  String? get currentLearningStyle => _currentLearningStyle;
  Map<String, String>? get learningStyleHistory => _learningStyleHistory;
  int? get overallLevel => _overallLevel;
  Map<String, int>? get levelHistory => _levelHistory;
  Map<String, String>? get currentLessons => _currentLessons;

  // Setters
  set id(String? id) {
    _id = id;
  }

  set currentLearningStyle(String? currentLearningStyle) {
    _currentLearningStyle = currentLearningStyle;
  }

  set learningStyleHistory(Map<String, String>? learningStyleHistory) {
    _learningStyleHistory = learningStyleHistory;
  }

  set overallLevel(int? overallLevel) {
    _overallLevel = overallLevel;
  }

  set levelHistory(Map<String, int>? levelHistory) {
    _levelHistory = levelHistory;
  }

  set currentLessons(Map<String, String>? currentLessons) {
    _currentLessons = currentLessons;
  }

  // fromJson method
  factory StudentDataModel.fromJson(Map<String, dynamic> json, String id) {
    return StudentDataModel.setAll(
      id: id,
      currentLearningStyle: json['currentLearningStyle'] as String?,
      learningStyleHistory: (json['learningStyleHistory'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)),
      overallLevel: json['overallLevel'] as int?,
      levelHistory: (json['levelHistory'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)),
      currentLessons: (json['currentLessons'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'currentLearningStyle': _currentLearningStyle,
      'learningStyleHistory': _learningStyleHistory,
      'overallLevel': _overallLevel,
      'levelHistory': _levelHistory,
      'currentLessons': _currentLessons,
    };
  }
}
