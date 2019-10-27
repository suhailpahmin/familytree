import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthApi {
  Future<dynamic> login(String email, String password);
  Future<String> register(User registerData);
  Future<FirebaseUser> getCurrentUser();
  Future signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}