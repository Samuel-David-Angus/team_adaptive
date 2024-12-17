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

  String? firstnameErrorMessage;
  String? lastnameErrorMessage;
  String? usernameErrorMesssage;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  // Getters
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
    validateFirstname();
    notifyListeners();
  }

  set lastname(String value) {
    _lastname = value;
    validateLastname();
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    validateUsername();
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

  // Validation Methods
  void validateFirstname() {
    if (_firstname.isEmpty) {
      firstnameErrorMessage = "First name cannot be empty.";
    } else if (_firstname.length < 2) {
      firstnameErrorMessage = "First name must be at least 2 characters.";
    } else {
      firstnameErrorMessage = null;
    }
  }

  void validateLastname() {
    if (_lastname.isEmpty) {
      lastnameErrorMessage = "Last name cannot be empty.";
    } else if (_lastname.length < 2) {
      lastnameErrorMessage = "Last name must be at least 2 characters.";
    } else {
      lastnameErrorMessage = null;
    }
  }

  void validateUsername() {
    if (_username.isEmpty) {
      usernameErrorMesssage = "Username cannot be empty.";
    } else if (_username.length < 3) {
      usernameErrorMesssage = "Username must be at least 3 characters.";
    } else {
      usernameErrorMesssage = null;
    }
  }

  void validateEmail() {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_email.isEmpty) {
      emailErrorMessage = "Email cannot be empty.";
    } else if (!regex.hasMatch(_email)) {
      emailErrorMessage = "Please enter a valid email address.";
    } else {
      emailErrorMessage = null;
    }
  }

  void validatePassword() {
    if (_password.isEmpty) {
      passwordErrorMessage = "Password cannot be empty.";
    } else if (_password.length < 6) {
      passwordErrorMessage = "Password must be at least 8 characters.";
    } else {
      passwordErrorMessage = null;
    }
  }

  // Register and Validation
  Future<bool> register() async {
    String type = userType == UserType.student ? 'student' : 'teacher';
    User user =
        User.setAll(null, firstname, lastname, username, email, password, type);
    return await service.register(user);
  }

  bool validate() {
    validateFirstname();
    validateLastname();
    validateUsername();
    validateEmail();
    validatePassword();
    notifyListeners(); // Notify listeners to update the UI with error messages
    return firstnameErrorMessage == null &&
        lastnameErrorMessage == null &&
        usernameErrorMesssage == null &&
        emailErrorMessage == null &&
        passwordErrorMessage == null;
  }
}
