import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api.dart';

class FirebaseAuthProvider implements AuthApi {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _fireAuth.currentUser();
    return user;
  }

  @override
  Future<FirebaseUser> login(String email, String password) async {
    AuthResult authResult = await _fireAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user;
  }

  @override
  Future<FirebaseUser> register(RegisterUser registerData) async {
    var authResult = await _fireAuth
        .createUserWithEmailAndPassword(
            email: registerData.email, password: registerData.password)
        .catchError((err) => err);
    if (authResult.user != null && authResult.user.uid.isNotEmpty) {
      await _fireStore
          .collection('users')
          .document(authResult.user.uid)
          .setData(
            ({
              "uid": authResult.user.uid,
              "name": registerData.name,
              "gender": registerData.gender,
              "email": registerData.email
            }),
          )
          .catchError((err) => err);
      return authResult.user;
    } else {
      return null;
    }
  }

  @override
  Future signOut() {
    return _fireAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _fireAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _fireAuth.currentUser();
    return user.isEmailVerified;
  }
}
