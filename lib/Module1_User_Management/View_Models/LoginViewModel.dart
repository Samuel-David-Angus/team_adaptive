import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

import '../Others/enums.dart';

// Define a ViewModel class for managing login state
class LoginViewModel extends ChangeNotifier {
  final AuthServices service = AuthServices();
  UserType _userType = UserType.student;
  String _email = "";
  String _password = "";
  String? emailErrorText;
  String? passwordErrorText;

  // Getters
  UserType get userType => _userType;
  String get email => _email;
  String get password => _password;

  // Setters
  set userType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    validateEmail();
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    validatePassword();
    notifyListeners();
  }

  // Method for handling login
  Future<bool> login() async {
    String type = userType == UserType.student ? 'student' : 'teacher';
    return await service.signIn(email, password, type);
  }

  bool validate() {
    return validateEmail() && validatePassword();
  }

  bool validateEmail() {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) {
      emailErrorText = "Not a valid email";
      return false;
    } else {
      emailErrorText = null;
      return true;
    }
  }

  bool validatePassword() {
    bool status = false;
    if (_password.isEmpty) {
      passwordErrorText = "No password provided";
    } else if (_password.length < 8) {
      passwordErrorText = "Password must be at least 8 characters long";
    } else {
      passwordErrorText = null;
      status = true;
    }
    return status;
  }
}
