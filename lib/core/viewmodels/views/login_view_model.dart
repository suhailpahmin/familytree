import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends BaseModel {
  FirebaseAuthProvider _auth;
  FirebaseUser _user;
  FirebaseUser get user => _user;
  String _email = "";
  String get email => _email;
  String _password = "";
  String get password => _password;

  LoginViewModel({FirebaseAuthProvider firebaseAuth}) : _auth = firebaseAuth;

  void loginUser(String email, String password) async {
    setBusy(true);
    _user = await _auth.login(email, password);
    notifyListeners();
    setBusy(false);
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