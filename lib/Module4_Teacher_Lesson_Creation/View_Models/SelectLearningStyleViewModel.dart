import 'package:flutter/material.dart';

class SelectLearningStyleViewModel extends ChangeNotifier {
  final List<String> learningStyles = ["Text", "Audio", "Visual"];
  List<String> selectedStyles = [];

  void addStyle(String style) {
    selectedStyles.add(style);
    notifyListeners();
  }

  void removeStyle(String style) {
    selectedStyles.remove(style);
    notifyListeners();
  }

  void reset() {
    selectedStyles = [];
  }

}