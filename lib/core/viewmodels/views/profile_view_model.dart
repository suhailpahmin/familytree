import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  User _user;
  User get user => _user;

  ProfileViewModel(
      {Firestore firestore, FirebaseAuth firebaseAuth, User user}) {
    _firestore = firestore;
    _fireAuth = firebaseAuth;
    _user = user;
  }

  Future updateUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future getUser(String userID) async {
    setBusy(true);
    if (userID != null) {
      await _firestore
          .collection('users')
          .document(userID)
          .get()
          .then((DocumentSnapshot snapshot) {
        var userData = new Map<String, dynamic>.from(snapshot.data);
        _user = userFromJson(userData);
        notifyListeners();
        setBusy(false);
      });
    } else {
      setBusy(false);
    }
  }

  Future logOut() {
    return _fireAuth.signOut();
  }
}
