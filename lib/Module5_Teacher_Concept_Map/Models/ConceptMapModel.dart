class ConceptMapModel {
  late String? _id;
  late String? _courseID;
  late Map<String, List<int>> _conceptMap;
  late Map<String, double> _maxFailureRates;
  late Map<String, List<String>> _lessonPartitions;

  // getters
  String? get id => _id;
  String? get courseID => _courseID;
  Map<String, List<int>> get conceptMap => _conceptMap;
  int get conceptCount => _conceptMap.length;
  Map<String, List<String>> get lessonPartitions => _lessonPartitions;
  Map<String, double> get maxFailureRates => _maxFailureRates;

  //setters
  set courseID(String? courseID) {
    _courseID = courseID;
  }

  set conceptMap(Map<String, List<int>> conceptMap) {
    _conceptMap = conceptMap;
  }

  ConceptMapModel.setAll(
      {required String? id,
      required String? courseID,
      required Map<String, List<int>> conceptMap,
      required Map<String, List<String>> lessonPartitions,
      required Map<String, double> maxFailureRates}) {
    _id = id;
    _courseID = courseID;
    _conceptMap = conceptMap;
    _lessonPartitions = lessonPartitions;
    _maxFailureRates = maxFailureRates;
  }

  factory ConceptMapModel.fromJson(Map<String, dynamic> json, String id) {
    // does not include externalLOToMap. must be set manually since JSON has contains no external map just the id to it. service will handle retrieving it
    Map<String, List<int>> conceptMapUnordered =
        (json['conceptMap'] as Map<String, dynamic>? ?? {}).map(
      (key, value) {
        final nonNullKey = key;
        final nonNullValue =
            (value as List<dynamic>?)?.map((e) => e as int).toList() ?? [];
        return MapEntry(nonNullKey, nonNullValue);
      },
    );

    List<String> order = List.from(json['order']).cast<String>();

    Map<String, List<int>> conceptMapOrdered = {
      for (String concept in order) concept: conceptMapUnordered[concept]!
    };

    Map<String, List<String>> partitions =
        (json['lessonPartitions'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, List<String>.from(value));
    });

    Map<String, double> maxFailureRates =
        (json['maxFailureRates'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, value as double);
    });

    return ConceptMapModel.setAll(
        id: id,
        courseID: json['courseID'],
        conceptMap: conceptMapOrdered,
        lessonPartitions: partitions,
        maxFailureRates: maxFailureRates);
  }

  Map<String, dynamic> toJson() {
    return {
      'courseID': _courseID,
      'order': _conceptMap.keys,
      'lessonPartitions': _lessonPartitions,
      'maxFailureRates': _maxFailureRates,
      'conceptMap': _conceptMap.map((key, value) => MapEntry(key, value)),
    };
  }

  double getMaxFailureRateOfLearningOutcome(String lO) {
    return _maxFailureRates[lO]!;
  }

  bool _addConcept(String concept, String lessonID) {
    if (_conceptMap.containsKey(concept)) {
      return false;
    }

    if (!_lessonPartitions.containsKey(lessonID)) {
      _lessonPartitions[lessonID] = [];
    }
    _lessonPartitions[lessonID]!.add(concept);

    _conceptMap.forEach((key, value) {
      value.add(0);
    });
    List<int> emptyList = List.generate(conceptCount + 1, (i) => 0);
    _conceptMap[concept] = emptyList;
    return true;
  }

  bool addExternalLearningOutcome(String externalLO, String lessonID) {
    if (!externalLO.startsWith('@')) {
      throw const FormatException(
          "If you want to add a local learning outcome. use addLocalLearningOutcome instead");
    }
    bool result = _addConcept(externalLO, lessonID);
    return result;
  }

  bool addLocalLearningOutcome(
      String localLearningOutcome, double maxFailureRate, String lessonID) {
    if (localLearningOutcome.startsWith('@')) {
      throw const FormatException(
          "If you want to add an external learning outcome. use addExternalLearningOutcome instead");
    }
    _maxFailureRates[localLearningOutcome] = maxFailureRate;
    return _addConcept(localLearningOutcome, lessonID);
  }

  bool removeConcept(String concept, String lessonID) {
    if (!_conceptMap.containsKey(concept)) {
      return false;
    }
    _lessonPartitions[lessonID]!.remove(concept);
    int indexToDelete = indexOfConcept(concept);
    _conceptMap.remove(concept);
    _conceptMap.forEach((key, value) {
      value.removeAt(indexToDelete);
    });
    return true;
  }

  int indexOfConcept(String concept) {
    return _conceptMap.keys.toList().indexOf(concept);
  }

  String conceptOfIndex(int index) {
    return _conceptMap.keys.toList()[index];
  }

  int areConnected(String concept1, dynamic concept2) {
    assert(concept2 is String || concept2 is int,
        "2nd arg must be either String or int");
    if (concept2 is int) {
      return _conceptMap[concept1]![concept2];
    }
    return _conceptMap[concept1]![indexOfConcept(concept2)];
  }

  bool willBeProperTree(String concept, String prereq) {
    List<String> prereqPrereqs = [];
    findAllPrerequisites(prereq, prereqPrereqs);
    if (prereqPrereqs.contains(concept)) {
      return false;
    }
    return true;
  }

  bool setPrerequisite(String concept, String prereq) {
    int index = indexOfConcept(prereq);
    if (index == -1) {
      return false;
    }
    int value = areConnected(concept, index);
    if (value == 0) {
      if (!willBeProperTree(concept, prereq)) {
        return false;
      }
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
    for (int index = 0; index < conceptCount; index++) {
      int value = areConnected(concept, index);
      if (value == 1) {
        String prereq = conceptOfIndex(index);
        findAllPrerequisites(prereq, foundPrerequisites);
      }
    }
  }

  int findConceptDepth(String concept) {
    for (int index = 0; index < conceptCount; index++) {
      if (_conceptMap[concept]![index] == 1) {
        String prereq = conceptOfIndex(index);
        return 1 + findConceptDepth(prereq);
      }
    }
    return 1;
  }

  Map<String, int> findRelativeDistancesOfPrerequisites(String concept,
      {int startDepth = 0}) {
    Map<String, int> map = {concept: startDepth};

    List<String> directPrerequisites = findDirectPrerequisites(concept);

    for (String directPrereq in directPrerequisites) {
      Map<String, int> preprereqs = findRelativeDistancesOfPrerequisites(
          directPrereq,
          startDepth: startDepth + 1);
      for (String concept in preprereqs.keys) {
        if (map.containsKey(concept)) {
          map[concept] = map[concept]! < preprereqs[concept]!
              ? map[concept]!
              : preprereqs[concept]!;
        }
        map[concept] = preprereqs[concept]!;
      }
    }
    return map;
  }

  List<String> findDirectPrerequisites(String concept) {
    List<String> prereqs = [];
    for (int i = 0; i < conceptMap.length; i++) {
      if (conceptMap[concept]![i] == 1) {
        prereqs.add(conceptOfIndex(i));
      }
    }
    return prereqs;
  }
}
