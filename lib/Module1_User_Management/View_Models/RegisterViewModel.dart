import 'package:flutter/material.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';

import '../Others/enums.dart';
import '../Services/AuthServices.dart';



class RegisterViewModel extends ChangeNotifier {
  final AuthServices service = AuthServices();
  UserType _userType = UserType.student;
  String _firstname = "";
  String _lastname = "";
  String _username = "";
  String _email = "";
  String _password = "";

  //Getters
  UserType get userType => _userType;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  // Setters
  set userType(UserType type) {
    _userType = type;
    notifyListeners();
  }
  set firstname(String value) {
    _firstname = value;
  }
  set lastname(String value) {
    _lastname = value;
  }
  set username(String value) {
    _username = value;
  }
  set email(String value) {
    _email = value;
  }
  set password(String value) {
    _password = value;
  }

  Future<bool> register() async {
    String type = userType == UserType.student ? 'student' : 'teacher';
    User user = User.setAll(
        null,
        firstname,
        lastname,
        username,
        email,
        password,
        type);
    return await service.register(user);
  }

  bool validate() {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return firstname.isNotEmpty && lastname.isNotEmpty && username.isNotEmpty && password.isNotEmpty && regex.hasMatch(email);
  }

}