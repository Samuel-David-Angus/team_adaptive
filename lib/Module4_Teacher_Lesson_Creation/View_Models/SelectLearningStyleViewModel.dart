import 'package:flutter/material.dart';

class SelectLearningStyleViewModel extends ChangeNotifier {
  final List<String> learningStyles = ["Text", "Audio", "Visual"];
  String selectedStyle = '';

  void setStyle(String style) {
    selectedStyle = style;
    notifyListeners();
  }


  void reset() {
    selectedStyle = '';
  }

}