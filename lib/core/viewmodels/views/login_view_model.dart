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

  Future<FirebaseUser> loginUser() async {
    setBusy(true);
    _user = await _auth.login(_email, _password);
    setBusy(false);
    if (_user != null && _user.uid.isNotEmpty) {
      return _user;
    } else {
      return null;
    }
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
