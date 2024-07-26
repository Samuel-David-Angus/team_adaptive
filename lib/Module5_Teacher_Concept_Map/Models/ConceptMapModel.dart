class ConceptMapModel {
  late String? _courseID;
  late Map<String, List<int>> _conceptMap;
  late int _conceptCount;

  // getters
  String? get courseID => _courseID;
  Map<String, List<int>> get conceptMap => _conceptMap;
  int get conceptCount => _conceptCount;

  //setters
  set courseID(String? courseID) {
    _courseID = courseID;
  }
  set conceptMap (Map<String, List<int>> conceptMap) {
    _conceptMap = conceptMap;
  }
  set conceptCount(int conceptCount) {
    _conceptCount = conceptCount;
  }

  ConceptMapModel.setAll({required String? courseID, required Map<String, List<int>> conceptMap}) {
    _courseID = courseID;
    _conceptMap = conceptMap;
    _conceptCount = conceptMap.length;
  }

  factory ConceptMapModel.fromJson(Map<String, dynamic> json, String id) {
    Map<String, List<int>> conceptMapUnordered = (json['conceptMap'] as Map<String, dynamic>? ?? {}).map(
          (key, value) {
        final nonNullKey = key ?? '';
        final nonNullValue = (value as List<dynamic>?)?.map((e) => e as int).toList() ?? [];
        return MapEntry(nonNullKey, nonNullValue);
      },
    );
    List<String> order = List.from(json['order']).cast<String>();
    Map<String, List<int>> conceptMapOrdered = {for (String concept in order) concept: conceptMapUnordered[concept]!};
    return ConceptMapModel.setAll(
      courseID: id,
      conceptMap: conceptMapOrdered,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': _conceptMap.keys,
      'conceptMap': _conceptMap.map((key, value) => MapEntry(key, value)),
    };
  }

  bool addConcept(String concept) {
    if (_conceptMap.containsKey(concept)) {
      return false;
    }
    _conceptMap.forEach(
        (key, value) {
          value.add(0);
        }
    );
    List<int> emptyList = List.generate(_conceptCount + 1, (i) => 0);
    _conceptMap[concept] = emptyList;
    _conceptCount++;
    return true;
  }

  bool removeConcept(String concept) {
    if (!_conceptMap.containsKey(concept)) {
      return false;
    }
    int indexToDelete = indexOfConcept(concept);
    _conceptMap.remove(concept);
    _conceptMap.forEach(
        (key, value) {
          value.removeAt(indexToDelete);
        }
    );
    conceptCount--;
    return true;
  }

  int indexOfConcept(String concept) {
    return _conceptMap.keys.toList().indexOf(concept);
  }

  String conceptOfIndex(int index) {
    return _conceptMap.keys.toList()[index];
  }

  int areConnected(String concept1, dynamic concept2) {
    assert(concept2 is String || concept2 is int, "2nd arg must be either String or int");
    if (concept2 is int) {
      return _conceptMap[concept1]![concept2];
    }
    return _conceptMap[concept1]![indexOfConcept(concept2)];
  }

  bool setPrerequisite(String concept, String prereq) {
    int index = indexOfConcept(prereq);
    if (index == -1) {
      return false;
    }
    int value =  areConnected(concept, index);
    if (value == 0) {
      _conceptMap[concept]![index] = 1;
    } else {
      _conceptMap[concept]![index] = 0;
    }
    return true;
  }

  void findAllPrerequisites(String concept, List<String> foundPrerequisites) {
    if (!foundPrerequisites.contains(concept)) {
      foundPrerequisites.add(concept);
    }
    for (int index = 0; index < _conceptCount; index++) {
      int value = areConnected(concept, index);
      if (value == 1) {
        String prereq = conceptOfIndex(index);
        findAllPrerequisites(prereq, foundPrerequisites);
      }
    }
  }

  int findConceptDepth(String concept) {
    for (int index = 0; index < _conceptCount; index++) {
      if (_conceptMap[concept]![index] == 1) {
        String prereq = conceptOfIndex(index);
        return 1 + findConceptDepth(prereq);
      }
    }
    return 1;
  }

}