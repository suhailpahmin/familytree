import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginViewModel extends BaseModel {
  FirebaseAuthProvider _auth;
  FirebaseUser _user;
  FirebaseUser get user => _user;
  String _email = "";
  String get email => _email;
  String _password = "";
  String get password => _password;
  String _error;
  String get error => _error;

  LoginViewModel({FirebaseAuthProvider firebaseAuth}) : _auth = firebaseAuth;

  Future<FirebaseUser> loginUser() async {
    setBusy(true);
    try {
      var _user = await _auth.login(_email, _password);
      setBusy(false);
      if (_user is PlatformException) {
        _error = _user.message;
        notifyListeners();
      } else {
        if (_user != null && _user.uid.isNotEmpty) {
          return _user;
        } else {
          return null;
        }
      }
    } on PlatformException catch (err) {
      _error = err.message;
      notifyListeners();
    }
    return null;
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }
}
