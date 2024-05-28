class ConceptMapModel {
  String? _courseID;
  Map<String, List<int>>? _conceptMap;

  // Getter for _courseID
  String? get courseID => _courseID;
  // Setter for _courseID
  set courseID(String? value) {
    _courseID = value;
  }

  // Getter for _conceptMap
  Map<String, List<int>>? get conceptMap => _conceptMap;
  // Setter for _conceptMap
  set conceptMap(Map<String, List<int>>? value) {
    _conceptMap = value;
  }

  ConceptMapModel.setAll({required String? courseID, required Map<String, List<int>>? conceptMap}) {
    _courseID = courseID;
    _conceptMap = conceptMap;
  }

  // Factory constructor for creating an instance from JSON
  factory ConceptMapModel.fromJson(Map<String, dynamic> json, String id) {
    Map<String, List<int>> conceptMap = (json['conceptMap'] as Map<String, dynamic>? ?? {}).map(
          (key, value) {
        final nonNullKey = key ?? '';
        final nonNullValue = (value as List<dynamic>?)?.map((e) => e as int).toList() ?? [];
        return MapEntry(nonNullKey, nonNullValue);
      },
    );
    return ConceptMapModel.setAll(
        courseID: id,
        conceptMap: conceptMap
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'conceptMap': _conceptMap?.map((key, value) => MapEntry(key, value)),
    };
  }

}