import 'package:familytree/core/models/authentication/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthApi {
  Future<FirebaseUser> login(String email, String password);
  Future<FirebaseUser> register(User registerData);
  Future<FirebaseUser> getCurrentUser();
  Future signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}