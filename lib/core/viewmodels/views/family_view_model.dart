import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/family/family_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FamilyViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  FamilyModel _familyResult;
  FamilyModel get familyResult => _familyResult;
  FamilyData _selfData;
  FamilyData get selfData => _selfData;

  FamilyViewModel({Firestore firestore, FirebaseAuth fireAuth}) {
    _firestore = firestore;
    _fireAuth = fireAuth;
  }

  void addFamilyMember(FamilyData newMember) async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    List<FamilyData> siblingList = [newMember];
    var documentID = await _firestore
        .collection('family')
        .where('initiator', isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.first.documentID);
    if (documentID.isNotEmpty) {
      await _firestore
          .collection('family')
          .document(documentID)
          .updateData({'siblings': FieldValue.arrayUnion(familiesToJson(siblingList))});
      _familyResult.siblings.add(newMember);
      _familyResult.siblings.sort((a, b) => a.birthDate.compareTo(b.birthDate));
      _familyResult.siblings.asMap().forEach((index, s) => {
            if (s.birthDate.compareTo(_selfData.birthDate) < 0)
              {
                if (s.gender == 'Lelaki')
                  {_familyResult.siblings[index].relation = 'Abang'}
                else if (s.gender == 'Wanita')
                  {_familyResult.siblings[index].relation = 'Kakak'}
              }
            else if (s.birthDate.compareTo(_selfData.birthDate) > 0)
              {
                if (s.gender == 'Lelaki')
                  {_familyResult.siblings[index].relation = 'Adik Lelaki'}
                else if (s.gender == 'Wanita')
                  {_familyResult.siblings[index].relation = 'Adik Perempuan'}
              }
          });
      notifyListeners();
    }
    setBusy(false);
  }

  // void registerFamily() async {
  //   setBusy(true);
  //   final id = shortid.generate();
  //   print(id);
  //   FirebaseUser user = await _fireAuth.currentUser();
  //   await _firestore.collection('family').document(id).setData({
  //     'members': [user.uid],
  //     'createdOn': DateTime.now(),
  //   });
  //   setBusy(false);
  // }

  // void cancelSearch() {
  //   _familyResult = null;
  //   _familyMembers = new List<String>();
  //   _familyID = null;
  //   notifyListeners();
  // }

  // void joinFamily() async {
  //   setBusy(true);
  //   FirebaseUser user = await _fireAuth.currentUser();
  //   await _firestore.collection('family').document(_familyID).updateData({"members": FieldValue.arrayUnion([user.uid])});
  //   _familyResult = null;
  //   notifyListeners();
  //   setBusy(false);
  // }

  Future getFamily() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    _familyResult = new FamilyModel();
    await _firestore
        .collection('family')
        .where('initiator', isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.documents != null && snapshot.documents.length > 0) {
        var fatherData = new Map<String, dynamic>.from(
            snapshot.documents.first.data['father']);
        var motherData = new Map<String, dynamic>.from(
            snapshot.documents.first.data['mother']);
        var siblingsData =
            new List<dynamic>.from(snapshot.documents.first.data['siblings']);
        _familyResult.father = familyFromJson(fatherData);
        _familyResult.mother = familyFromJson(motherData);
        _familyResult.siblings = familiesFromJson(siblingsData);
        await _firestore
            .collection('users')
            .document(user.uid)
            .get()
            .then((DocumentSnapshot value) {
          _selfData = new FamilyData(
            name: value.data['name'],
            phoneNumber: value.data['phone'],
            birthDate: value.data['birthdate'].toDate(),
            relation: 'Anda',
            gender: 'Lelaki',
          );
          _familyResult.siblings.add(_selfData);
          DateTime userBirthdate = value.data['birthdate'].toDate();
          _familyResult.siblings
              .sort((a, b) => a.birthDate.compareTo(b.birthDate));
          _familyResult.siblings.asMap().forEach((index, s) => {
                if (s.birthDate.compareTo(userBirthdate) < 0)
                  {
                    if (s.gender == 'Lelaki')
                      {_familyResult.siblings[index].relation = 'Abang'}
                    else if (s.gender == 'Wanita')
                      {_familyResult.siblings[index].relation = 'Kakak'}
                  }
                else if (s.birthDate.compareTo(userBirthdate) > 0)
                  {
                    if (s.gender == 'Lelaki')
                      {_familyResult.siblings[index].relation = 'Adik Lelaki'}
                    else if (s.gender == 'Wanita')
                      {
                        _familyResult.siblings[index].relation =
                            'Adik Perempuan'
                      }
                  }
              });
        });
        notifyListeners();
        setBusy(false);
      } else {
        setBusy(false);
      }
    });
    setBusy(false);
    return null;
  }

  // void getFamily() async {
  //   setBusy(true);
  //   FirebaseUser user = await _fireAuth.currentUser();
  //   _familyMembers = new List<String>();
  //   await _firestore
  //       .collection('family')
  //       .where('members', arrayContains: user.uid)
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     if (snapshot.documents != null && snapshot.documents.length > 0) {
  //       _familyID = snapshot.documents.first.documentID;
  //       snapshot.documents.first.data['members'].forEach((member) async {
  //         await _firestore
  //             .collection('users')
  //             .where('uid', isEqualTo: member)
  //             .getDocuments()
  //             .then((QuerySnapshot snapshot) {
  //           _familyMembers.add(snapshot.documents.first.data['name']);
  //         });
  //         notifyListeners();
  //         setBusy(false);
  //       });
  //     } else {
  //       setBusy(false);
  //     }
  //   });
  // }
}
