import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootViewModel extends BaseModel {
  FirebaseAuthProvider _auth;
  FirebaseUser _user;
  FirebaseUser get user => _user;

  RootViewModel({FirebaseAuthProvider firebaseAuthProvider}) : _auth = firebaseAuthProvider;

  void initializeLogin() async {
    setBusy(true);
    _user = await _auth.getCurrentUser();
    notifyListeners();
    setBusy(false);
  }
}