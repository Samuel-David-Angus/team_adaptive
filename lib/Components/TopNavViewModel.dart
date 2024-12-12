import 'package:flutter/material.dart';

enum SELECTED { HOME, COURSES, ABOUT, NONE }

class TopNavViewmodel extends ChangeNotifier {
  SELECTED highlighted = SELECTED.HOME;
  final List<String> navBtns = ['Home', 'Courses', 'About'];

  void setSelected(SELECTED selected) {
    highlighted = selected;
    notifyListeners();
  }
}
