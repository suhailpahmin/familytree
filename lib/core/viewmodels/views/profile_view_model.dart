import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/register_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  User _user;
  User get user => _user;

  ProfileViewModel({Firestore firestore, FirebaseAuth firebaseAuth}) {
    _firestore = firestore;
    _fireAuth = firebaseAuth;
  }

  Future getUser() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    await _firestore
        .collection('users')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var userData = new Map<String, dynamic>.from(snapshot.data);
      _user = userFromJson(userData);
      notifyListeners();
      setBusy(false);
    });
  }

  Future logOut() {
    return _fireAuth.signOut();
  }
}
