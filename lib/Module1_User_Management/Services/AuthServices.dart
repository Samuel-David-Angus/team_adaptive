import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../Models/User.dart';


class AuthServices with ChangeNotifier{
  static final AuthServices _instance = AuthServices._internal();

  fauth.User? _currentUser;
  User? _userInfo;

  fauth.User? get currentUser => _currentUser;
  User? get userInfo => _userInfo;

  AuthServices._internal() {
    _currentUser = fauth.FirebaseAuth.instance.currentUser;
    _userInfo = null;
    if (_currentUser != null) {
      _fetchUserInfo(); // Fetch user info immediately if user is already logged in
    }
    fauth.FirebaseAuth.instance.authStateChanges().listen((fauth.User? user) {
      _currentUser = user;
      if (_currentUser != null) {
        _fetchUserInfo();
      } else {
        _userInfo = null;
        notifyListeners();
      }
    });
  }

  factory AuthServices() {
    return _instance;
  }

  Future<bool> signIn(String email, String password, String type) async {
    try {
      fauth.UserCredential credential = await fauth.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      fauth.User? credUser = credential.user;
      if (credUser != null) {
        await _fetchUserInfo();
        if (_userInfo?.type == type) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("some error occured");
      return false;
    }
  }

  Future<bool> register(User user) async {
    try {
      fauth.UserCredential credential = await fauth.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email ?? '', password: user.password ?? '');
      fauth.User? credUser = credential.user;
      if (credUser != null) {
        user.id = credUser.uid;
        await addUserInfo(user);
        return true;
      }
      return false;

    } catch (e) {
      print("some error occured $e ");
      return false;
    }
  }

  Future<void> signOut() async {
    await fauth.FirebaseAuth.instance.signOut();
  }

  Future<void> _fetchUserInfo() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(_currentUser!.uid)
            .get();

        if (documentSnapshot.exists) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          _userInfo = User.setAll(
            _currentUser!.uid,
            data['firstname'],
            data['lastname'],
            data['username'],
            data['email'],
            null,
            data['type'],
          );
        } else {
          print('User document does not exist in Firestore');
          _userInfo = null;
        }
      } catch (e) {
        print('Error fetching user info: $e');
        _userInfo = null;
      }
      notifyListeners();
    }
  }

  Future<void> addUserInfo(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(user.id)
          .set({
        'firstname': user.firstname,
        'lastname': user.lastname,
        'username': user.username,
        'email': user.email,
        'type': user.type,
        // Add other user properties as needed
      });
      print('User information added to Firestore');
    } catch (e) {
      print('Error adding user information to Firestore: $e');
      // Handle error as needed
    }
  }



}