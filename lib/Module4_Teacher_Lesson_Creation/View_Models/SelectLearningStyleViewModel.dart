import 'package:flutter/material.dart';

class SelectLearningStyleViewModel extends ChangeNotifier {
  final List<String> learningStyles = ["Text", "Audio", "Visual"];
  String selectedStyle = '';
  String prevStyle = '';

  void setStyle(String style) {
    selectedStyle = style;
    notifyListeners();
  }

  void cancelStyle() {
    selectedStyle = prevStyle;
  }

  void confirmStyle() {
    prevStyle = selectedStyle;
  }
}
