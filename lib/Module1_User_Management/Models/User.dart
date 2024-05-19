import 'package:flutter/material.dart';

class User {
  String? _id;
  String? _firstname;
  String? _lastname;
  String? _username;
  String? _email;
  String? _password;
  String? _type;

  String? get id => _id;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get username => _username;
  String? get email => _email;
  String? get password => _password;
  String? get type => _type;

  set id (String? value) {
    _id = value;
  }
  set firstname(String? value) {
    _firstname = value;
  }
  set lastname(String? value) {
    _lastname = value;
  }
  set username(String? value) {
    _username = value;
  }
  set email(String? value) {
    _email = value;
  }
  set password(String? value) {
    _password = value;
  }
  set type(String? value) {
    _type = value;
  }

  User.setAll(this._id, this._firstname, this._lastname, this._username, this._email,
      this._password, this._type);

  User();
}