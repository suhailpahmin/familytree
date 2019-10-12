import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;

  ProfileViewModel({Firestore firestore, FirebaseAuth firebaseAuth}) {
    _firestore = firestore;
    _fireAuth = firebaseAuth;
  }

  Future logOut() {
    return _fireAuth.signOut();
  }
}
