import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/authentication/user_model.dart';
import 'package:familytree/core/models/family/family_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/providers/sms_provider.dart';
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
  SmsProvider _smsProvider;
  User _user;

  FamilyViewModel(
      {Firestore firestore,
      FirebaseAuth fireAuth,
      SmsProvider smsProvider,
      User user}) {
    _firestore = firestore;
    _fireAuth = fireAuth;
    _smsProvider = smsProvider;
    _user = user;
  }

  void addFamilyMember(FamilyData newMember) async {
    setBusy(true);
    if (newMember.relation == 'Adik Beradik') {
      List<FamilyData> siblingList = [newMember];
      await _firestore.collection('family').document(_familyID).updateData(
            ({
              'siblings': FieldValue.arrayUnion(
                familiesToJson(siblingList),
              ),
            }),
          );
      _familyResult.siblings.add(newMember);
    } else if (newMember.relation == 'Isteri' ||
        newMember.relation == 'Suami') {
      await _firestore.collection('family').document(_familyID).updateData({
        'spouse': familyToJson(newMember),
      });
      _familyResult.spouse = newMember;
    } else if (newMember.relation == 'Anak') {
      List<FamilyData> childrenList = [newMember];
      await _firestore.collection('family').document(_familyID).updateData(
            ({
              'children': FieldValue.arrayUnion(
                familiesToJson(childrenList),
              ),
            }),
          );
      _familyResult.children.add(newMember);
    }
    var numbers = newMember.phoneNumber;
    if (newMember.secondNumber != null) {
      numbers += newMember.secondNumber;
    }
    if (newMember.thirdNumber != null) {
      numbers += newMember.thirdNumber;
    }
    await _smsProvider.sendSms(numbers,
        'You are invited to Wareih by ${_user.name}! Download it now on Playstore to join the family!');

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
          _totalRegisteredMember += 2;
          if (doc.data['spouse'] != null) {
            var wifeData = new Map<String, dynamic>.from(doc.data['spouse']);
            _familyResult.spouse = familyFromJson(wifeData);
            _totalRegisteredMember++;
          }
          if (doc.data['siblings'] != null) {
            var siblingsData = new List<dynamic>.from(doc.data['siblings']);
            _familyResult.siblings = familiesFromJson(siblingsData);
            _totalRegisteredMember += _familyResult.siblings.length;
          } else {
            _familyResult.siblings = new List<FamilyData>();
          }

          if (doc.data['children'] != null) {
            var childrenData = new List<dynamic>.from(doc.data['children']);
            _familyResult.children = familiesFromJson(childrenData);
            _totalRegisteredMember += _familyResult.children.length;
          } else {
            _familyResult.children = new List<FamilyData>();
          }

          _familyResult.father = familyFromJson(fatherData);
          _familyResult.mother = familyFromJson(motherData);

          if (_familyResult.father.id != user.uid &&
              _familyResult.mother.id != user.uid) {
            _familyResult.father.relation = 'Bapa';
            _familyResult.mother.relation = 'Ibu';
            if (_familyResult.spouse != null) {
              if (_familyResult.spouse.gender == 'Lelaki') {
                _familyResult.spouse.relation = 'Suami';
              } else if (_familyResult.spouse.gender == 'Wanita') {
                _familyResult.spouse.relation = 'Isteri';
              }
            }
            _familyResult.siblings
                .sort((a, b) => a.birthDate.compareTo(b.birthDate));
            DateTime userBirthdate = _familyResult.siblings
                .where((s) => s.id == user.uid)
                .first
                .birthDate;
            _familyResult.siblings.asMap().forEach((index, s) {
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

          if (_familyResult.children != null &&
              _familyResult.children.length > 0) {
            _familyResult.children
                .sort((a, b) => a.birthDate.compareTo(b.birthDate));
            _familyResult.children.forEach((s) => s.relation = 'Anak');
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
