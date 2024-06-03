class ConceptMapModel {
  late String _id;
  late String _courseID;
  late List<String> _concepts;
  late List<List<bool>> _conceptMatrix;
  late int _conceptCount;
  late List<int> _conceptDepths;
  late int _treeHeight;

  ConceptMapModel.setAll({
    required String id,
    required String courseID,
    required List<String> concepts,
    required List<List<bool>> conceptMatrix
  }) {
    _id = id;
    _courseID = courseID;
    _concepts = concepts;
    _conceptMatrix = conceptMatrix;
    _conceptCount = _concepts.length;
    _conceptDepths = List<int>.filled(_concepts.length, 0);
    setDepthsAndHeight();
  }

  int findIndexOfConcept(String concept) {
    for (int i = 0; i < _conceptCount; i++) {
      if (concept == _concepts[i]) return i;
    }
    return -1;
  }

  void setConceptConnection(String preRequisite, String postRequisite, bool connection) {
    int from = findIndexOfConcept(preRequisite);
    int to = findIndexOfConcept(postRequisite);
    _conceptMatrix[from][to] = connection;
  }

  void findPreRequisites(int to, List<int> foundPreRequisites) {
    foundPreRequisites[to] = 1;
    for (int from = 0; from < _conceptCount; from++) {
      if (_conceptMatrix[from][to]) findPreRequisites(from, foundPreRequisites);
    }
  }

  int getDepth(int to) {
    for (int from = 0; from < _conceptCount; from++) {
      if (_conceptMatrix[from][to]) return 1 + getDepth(from);
    }
    return 1;
  }

  void setDepthsAndHeight() {
    int maxDepth = 0;
    for (int conceptIndex = 0; conceptIndex < _conceptCount; conceptIndex++) {
      int depth = getDepth(conceptIndex);
      _conceptDepths[conceptIndex] = depth;
      if (depth > maxDepth) maxDepth = depth;
    }
    _treeHeight = maxDepth;
  }

  // Getter and Setter for _id
  String get id => _id;
  set id(String id) {
    _id = id;
  }

  // Getter and Setter for _courseID
  String get courseID => _courseID;
  set courseID(String courseID) {
    _courseID = courseID;
  }

  // Getter and Setter for _concepts
  List<String> get concepts => _concepts;
  set concepts(List<String> concepts) {
    _concepts = concepts;
  }

  // Getter and Setter for _conceptMatrix
  List<List<bool>> get conceptMatrix => _conceptMatrix;
  set conceptMatrix(List<List<bool>> conceptMatrix) {
    _conceptMatrix = conceptMatrix;
  }

  // Getter and Setter for _conceptCount
  int get conceptCount => _conceptCount;
  set conceptCount(int conceptCount) {
    _conceptCount = conceptCount;
  }

  // Getter and Setter for _conceptDepths
  List<int> get conceptDepths => _conceptDepths;
  set conceptDepths(List<int> conceptDepths) {
    _conceptDepths = conceptDepths;
  }

  factory ConceptMapModel.fromJson(Map<String, dynamic> json, String id) {
    return ConceptMapModel.setAll(
      id: id,
      courseID: json['courseID'],
      concepts: List<String>.from(json['concepts']),
      conceptMatrix: List<List<bool>>.from(json['conceptMatrix']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseID': courseID,
      'concepts': concepts,
      'conceptMatrix': conceptMatrix
    };
  }
}