import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/providers/sharedpreferences_helper.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileViewModel extends BaseModel {
  String _birthPlace = '';
  String get birthPlace => _birthPlace;
  String _currentAddress = '';
  String get currentAddress => _currentAddress;
  String _currentState = '';
  String get currentState => _currentState;
  Firestore _firestore;
  FirebaseStorage _fireStorage;
  String _profileImage;
  String get profileImage => _profileImage;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  EditProfileViewModel({Firestore firestore, FirebaseStorage firebaseStorage}) {
    _firestore = firestore;
    _fireStorage = firebaseStorage;
  }

  Future updateProfile(User user) async {
    setBusy(true);
    await _firestore.collection('users').document(user.id).updateData(
      {
        'birthPlace': _birthPlace,
        'currentAddress': _currentAddress,
        'currentState': _currentState,
        'image': _profileImage,
      },
    );
    await _firestore
        .collection('userfamily')
        .where('userID', isEqualTo: user.id)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      await _firestore
          .collection('family')
          .document(snapshot.documents.first.data['familyID'])
          .get()
          .then((DocumentSnapshot doc) async {
        if (doc.exists && doc.data != null) {
          var fatherData = new Map<String, dynamic>.from(doc.data['father']);
          var father = familyFromJson(fatherData);
          if (father.id != null && father.id == user.id) {
            father.image = _profileImage;
            await _firestore
                .collection('family')
                .document(doc.documentID)
                .updateData({'father': father.toJson()});
          } else {
            var motherData = new Map<String, dynamic>.from(doc.data['mother']);
            var mother = familyFromJson(motherData);
            if (mother.id != null && mother.id == user.id) {
              mother.image = _profileImage;
              await _firestore
                  .collection('family')
                  .document(doc.documentID)
                  .updateData({'mother': mother.toJson()});
            } else {
              var siblingsData = new List<dynamic>.from(doc.data['siblings']);
              var siblings = familiesFromJson(siblingsData);
              siblings.asMap().forEach((index, s) {
                if (s.id == user.id) {
                  siblings[index].image = _profileImage;
                }
              });
              await _firestore
                  .collection('family')
                  .document(doc.documentID)
                  .updateData({'siblings': familiesToJson(siblings)});
            }
          }
        }
      });
    });

    if (_sharedPreferences == null) {
      _sharedPreferences = await _prefs;
    }
    user.image = _profileImage;
    user.birthPlace = _birthPlace;
    user.currentAddress = _currentAddress;
    user.currentState = _currentState;
    String userString = jsonEncode(user);
    SharedPreferencesHelper.logUser(_sharedPreferences, userString);
    setBusy(false);
  }

  Future<bool> uploadProfileImage(File image) async {
    if (image != null) {
      final StorageReference storageReference =
          _fireStorage.ref().child('profilepictures/${basename(image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      final StorageTaskSnapshot downloadURL = (await uploadTask.onComplete);
      String imageURL = (await downloadURL.ref.getDownloadURL());
      if (imageURL != null && imageURL.isNotEmpty) {
        _profileImage = imageURL;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void setBirthPlace(String value) {
    _birthPlace = value;
    notifyListeners();
  }

  void setCurrentAddress(String value) {
    _currentAddress = value;
    notifyListeners();
  }

  void setCurrentState(String value) {
    _currentState = value;
    notifyListeners();
  }
}
