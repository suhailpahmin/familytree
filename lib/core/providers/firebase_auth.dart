import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/models/family/family_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/providers/sharedpreferences_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

class FirebaseAuthProvider implements AuthApi {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  StreamController<User> _userController = StreamController<User>.broadcast();
  Stream<User> get user => _userController.stream;
  StreamController<FamilyModel> _familyController =
      StreamController<FamilyModel>();
  Stream<FamilyModel> get family => _familyController.stream;

  @override
  Future<FirebaseUser> getCurrentUser() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await _prefs;
    }
    FirebaseUser user = await _fireAuth.currentUser();
    if (user != null && user.uid.isNotEmpty) {
      var doc = await _fireStore.collection('users').document(user.uid).get();
      if (doc.data != null) {
        User userData = new User(
          email: doc.data['email'],
          name: doc.data['name'],
          gender: doc.data['gender'],
          phoneNumber: doc.data['phone'],
          birthDate: doc.data['birthDate'].toDate(),
          image: doc.data['image'],
          id: user.uid,
          birthPlace:
              doc.data['birthPlace'] != null ? doc.data['birthPlace'] : null,
          currentAddress: doc.data['currentAddress'] != null
              ? doc.data['currentAddress']
              : null,
          currentState: doc.data['currentState'] != null
              ? doc.data['currentState']
              : null,
          secondNumber: doc.data['secondNumber'] != null
              ? doc.data['secondNumber']
              : null,
          thirdNumber:
              doc.data['thirdNumber'] != null ? doc.data['thirdNumber'] : null,
        );
        _userController.add(userData);
        String userString = jsonEncode(userData);
        SharedPreferencesHelper.logUser(_sharedPreferences, userString);
      }
      return user;
    }
    return null;
  }

  @override
  Future<dynamic> login(String email, String password) async {
    try {
      if (_sharedPreferences == null) {
        _sharedPreferences = await _prefs;
      }
      AuthResult authResult = await _fireAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        var doc = await _fireStore
            .collection('users')
            .document(authResult.user.uid)
            .get();
        if (doc.data != null) {
          User userData = new User(
            email: doc.data['email'],
            name: doc.data['name'],
            gender: doc.data['gender'],
            phoneNumber: doc.data['phone'],
            birthDate: doc.data['birthDate'].toDate(),
            id: authResult.user.uid,
            birthPlace:
                doc.data['birthPlace'] != null ? doc.data['birthPlace'] : null,
            currentAddress: doc.data['currentAddress'] != null
                ? doc.data['currentAddress']
                : null,
            currentState: doc.data['currentState'] != null
                ? doc.data['currentState']
                : null,
            secondNumber: doc.data['secondNumber'] != null
                ? doc.data['secondNumber']
                : null,
            thirdNumber: doc.data['thirdNumber'] != null
                ? doc.data['thirdNumber']
                : null,
          );
          _userController.add(userData);
          String userString = jsonEncode(userData);
          SharedPreferencesHelper.logUser(_sharedPreferences, userString);
        }
        return authResult.user;
      }
    } on PlatformException catch (err) {
      return err;
    }
    return null;
  }

  Future<String> registerFamily(String userID, FamilyData father,
      FamilyData mother, List<FamilyData> siblings) async {
    FamilyModel newFamily = new FamilyModel();
    try {
      FirebaseUser user = await _fireAuth.currentUser();
      await _fireStore
          .collection('users')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot doc) {
        siblings.add(
          new FamilyData(
            name: doc.data['name'],
            phoneNumber: doc.data['phone'],
            birthDate: doc.data['birthDate'].toDate(),
            gender: doc.data['gender'],
            id: user.uid,
          ),
        );
      });
      return await _fireStore.collection('family').add({
        'father': father.toJson(),
        'mother': mother.toJson(),
        'initiator': userID,
        'siblings': familiesToJson(siblings)
      }).then((DocumentReference doc) async {
        await _fireStore
            .collection('userfamily')
            .document()
            .setData({'userID': userID, 'familyID': doc.documentID});
        newFamily.father = father;
        newFamily.mother = mother;
        newFamily.siblings = siblings;
        _familyController.add(newFamily);
        return 'Success';
      });
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<String> register(User registerData) async {
    try {
      return await createUser(registerData).then((user) async {
        if (!user.contains('Failed')) {
          registerData.id = user;
          var date =
              DateFormat('yyyyMMddTHHmmss').format(registerData.birthDate);
          return await _fireStore
              .collection('family')
              .where('siblings', arrayContains: {
                'birthDate': date,
                'gender': registerData.gender,
                'id': null,
                'image': null,
                'name': registerData.name,
                'phoneNumber': registerData.phoneNumber,
                'secondNumber': null,
                'thirdNumber': null,
              })
              .limit(1)
              .getDocuments()
              .then((QuerySnapshot snapshot) async {
                if (snapshot.documents != null &&
                    snapshot.documents.length > 0) {
                  var siblingsData = new List<dynamic>.from(
                      snapshot.documents.first.data['siblings']);
                  var userData = new FamilyData(
                    name: registerData.name,
                    id: registerData.id,
                    birthDate: registerData.birthDate,
                    gender: registerData.gender,
                    phoneNumber: registerData.phoneNumber,
                    secondNumber: registerData.secondNumber,
                    thirdNumber: registerData.thirdNumber,
                  );
                  List<FamilyData> siblings = familiesFromJson(siblingsData);
                  siblings.asMap().forEach((index, s) {
                    if (s.phoneNumber == registerData.phoneNumber) {
                      siblings[index] = userData;
                    }
                  });
                  await _fireStore
                      .collection('family')
                      .document(snapshot.documents.first.documentID)
                      .updateData({'siblings': familiesToJson(siblings)});
                  await _fireStore.collection('userfamily').document().setData({
                    'userID': user,
                    'familyID': snapshot.documents.first.documentID
                  });
                  return 'Has Family';
                } else {
                  return  await _fireStore
                      .collection('family')
                      .where('mother.phoneNumber',
                          isEqualTo: registerData.phoneNumber)
                      .limit(1)
                      .getDocuments()
                      .then((QuerySnapshot snapshot) async {
                    if (snapshot.documents != null &&
                        snapshot.documents.length > 0) {
                      var familyRef = _fireStore
                          .collection('family')
                          .document(snapshot.documents.first.documentID);
                      await familyRef
                          .updateData({'mother': registerData.toJson()});
                      await _fireStore
                          .collection('userfamily')
                          .document()
                          .setData({
                        'userID': user,
                        'familyID': familyRef.documentID
                      });
                      return 'Has Family';
                    } else {
                      return await _fireStore
                          .collection('family')
                          .where('father.phoneNumber',
                              isEqualTo: registerData.phoneNumber)
                          .limit(1)
                          .getDocuments()
                          .then((QuerySnapshot snapshot) async {
                        if (snapshot.documents != null &&
                            snapshot.documents.length > 0) {
                          var familyRef = _fireStore
                              .collection('family')
                              .document(snapshot.documents.first.documentID);
                          await familyRef
                              .updateData({'father': registerData.toJson()});
                          await _fireStore
                              .collection('userfamily')
                              .document()
                              .setData({
                            'userID': user,
                            'familyID': familyRef.documentID
                          });
                          return 'Has Family';
                        } else {
                          return user;
                        }
                      });
                    }
                  });
                }
              });
        } else {
          return user;
        }
      });
    } catch (err) {
      throw err;
    }
  }

  Future<String> createUser(User registerData) async {
    try {
      if (_sharedPreferences == null) {
        _sharedPreferences = await _prefs;
      }
      final FirebaseUser user = (await _fireAuth.createUserWithEmailAndPassword(
        email: registerData.email,
        password: registerData.password,
      ))
          .user;

      if (user != null && user.uid.isNotEmpty) {
        registerData.id = user.uid;
        await _fireStore.collection('users').document(user.uid).setData(
              ({
                "id": user.uid,
                "name": registerData.name,
                "gender": registerData.gender,
                "email": registerData.email,
                "phone": registerData.phoneNumber,
                "birthDate": registerData.birthDate,
                "secondNumber": registerData.secondNumber,
                "thirdNumber": registerData.thirdNumber,
              }),
            );
        _userController.add(registerData);
        String userString = jsonEncode(registerData);
        SharedPreferencesHelper.logUser(_sharedPreferences, userString);
        return registerData.id;
      } else {
        return 'Failed creating user';
      }
    } catch (err) {
      throw err;
    }
  }

  @override
  Future signOut() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await _prefs;
    }
    SharedPreferencesHelper.logOutUser(_sharedPreferences);
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
