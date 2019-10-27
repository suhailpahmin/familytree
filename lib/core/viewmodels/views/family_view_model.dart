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
  String _familyID = '';
  String get familyID => _familyID;
  int _totalRegisteredMember = 0;
  int get totalRegisteredMember => _totalRegisteredMember;

  FamilyViewModel({Firestore firestore, FirebaseAuth fireAuth}) {
    _firestore = firestore;
    _fireAuth = fireAuth;
  }

  void addFamilyMember(FamilyData newMember) async {
    setBusy(true);
    List<FamilyData> siblingList = [newMember];
    await _firestore.collection('family').document(_familyID).updateData(
          ({
            'siblings': FieldValue.arrayUnion(
              familiesToJson(siblingList),
            ),
          }),
        );
    _familyResult.siblings.add(newMember);
    notifyListeners();
    setBusy(false);
  }

  Future getFamily() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    _familyResult = new FamilyModel();
    await _firestore
        .collection('userfamily')
        .where('userID', isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      await _firestore
          .collection('family')
          .document(snapshot.documents.first.data['familyID'])
          .get()
          .then((DocumentSnapshot doc) async {
        if (doc.exists != null && doc.data != null) {
          _familyID = doc.documentID;
          var fatherData = new Map<String, dynamic>.from(doc.data['father']);
          var motherData = new Map<String, dynamic>.from(doc.data['mother']);
          _totalRegisteredMember = 2;
          var siblingsData = new List<dynamic>.from(doc.data['siblings']);
          _familyResult.father = familyFromJson(fatherData);
          _familyResult.mother = familyFromJson(motherData);
          _familyResult.siblings = familiesFromJson(siblingsData);

          if (_familyResult.father.id != user.uid &&
              _familyResult.mother.id != user.uid) {
            _familyResult.father.relation = 'Bapa';
            _familyResult.mother.relation = 'Ibu';
            _familyResult.siblings
                .sort((a, b) => a.birthDate.compareTo(b.birthDate));
            DateTime userBirthdate = _familyResult.siblings
                .where((s) => s.id == user.uid)
                .first
                .birthDate;
            _familyResult.siblings.asMap().forEach((index, s) {
              _totalRegisteredMember++;
              if (s.id == user.uid) {
                _familyResult.siblings[index].relation = 'Anda';
              }
              if (s.birthDate.compareTo(userBirthdate) < 0) {
                if (s.gender == 'Lelaki') {
                  _familyResult.siblings[index].relation = 'Abang';
                } else if (s.gender == 'Wanita') {
                  _familyResult.siblings[index].relation = 'Kakak';
                }
              } else if (s.birthDate.compareTo(userBirthdate) > 0) {
                if (s.gender == 'Lelaki') {
                  _familyResult.siblings[index].relation = 'Adik Lelaki';
                } else if (s.gender == 'Wanita') {
                  _familyResult.siblings[index].relation = 'Adik Perempuan';
                }
              }
            });
          } else {
            if (_familyResult.mother.id == user.uid) {
              _familyResult.mother.relation = 'Anda';
              _familyResult.father.relation = 'Suami';
            } else if (_familyResult.father.id == user.uid) {
              _familyResult.father.relation = 'Anda';
              _familyResult.mother.relation = 'Isteri';
            }
            _familyResult.siblings
                .sort((a, b) => a.birthDate.compareTo(b.birthDate));
            _familyResult.siblings.forEach((s) => s.relation = 'Anak');
          }
          notifyListeners();
          setBusy(false);
        } else {
          setBusy(false);
        }
      });
    });
  }
}
