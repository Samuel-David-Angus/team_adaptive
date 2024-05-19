import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

import '../Others/enums.dart';


// Define a ViewModel class for managing login state
class LoginViewModel extends ChangeNotifier {
  final AuthServices service = AuthServices();
  UserType _userType = UserType.student;
  String _email = "";
  String _password = "";

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
  }
  set password(String value) {
    _password = value;
  }

  // Method for handling login
  Future<bool> login() async {
    String type = userType == UserType.student ? 'student' : 'teacher';
    return await service.signIn(email, password, type);
  }

  bool validate() {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email) && password.isNotEmpty;
  }

}