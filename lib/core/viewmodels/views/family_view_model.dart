import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/family/family_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shortid/shortid.dart';

class FamilyViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  String _familyID;
  String get familyID => _familyID;
  List<String> _familyMembers;
  List<String> get familyMembers => _familyMembers;
  FamilyModel _familyResult;
  FamilyModel get familyResult => _familyResult;

  FamilyViewModel({Firestore firestore, FirebaseAuth fireAuth}) {
    _firestore = firestore;
    _fireAuth = fireAuth;
  }

  void registerFamily() async {
    setBusy(true);
    final id = shortid.generate();
    print(id);
    FirebaseUser user = await _fireAuth.currentUser();
    await _firestore.collection('family').document(id).setData({
      'members': [user.uid],
      'createdOn': DateTime.now(),
    });
    setBusy(false);
  }

  void cancelSearch() {
    _familyResult = null;
    _familyMembers = new List<String>();
    _familyID = null;
    notifyListeners();
  }

  void joinFamily() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    await _firestore.collection('family').document(_familyID).updateData({"members": FieldValue.arrayUnion([user.uid])});
    _familyResult = null;
    notifyListeners();
    setBusy(false);
  }

  Future<FamilyModel> findFamily(String familyCode) async {
    setBusy(true);
    if (familyCode.isNotEmpty) {
      return await _firestore
          .collection('family')
          .document(familyCode)
          .get()
          .then((DocumentSnapshot doc) {
        FamilyModel family = FamilyModel.fromJson(doc.data);
        _familyID = doc.documentID;
        _familyResult = family;
        family.members.forEach((member) async {
          await _firestore
              .collection('users')
              .where('uid', isEqualTo: member)
              .getDocuments()
              .then((QuerySnapshot snapshot) {
            _familyMembers.add(snapshot.documents.first.data['name']);
          });
          setBusy(false);
        });
        notifyListeners();
        return family;
      });
    }
    setBusy(false);
    return null;
  }

  void getFamily() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    _familyMembers = new List<String>();
    await _firestore
        .collection('family')
        .where('members', arrayContains: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents != null && snapshot.documents.length > 0) {
        _familyID = snapshot.documents.first.documentID;
        snapshot.documents.first.data['members'].forEach((member) async {
          await _firestore
              .collection('users')
              .where('uid', isEqualTo: member)
              .getDocuments()
              .then((QuerySnapshot snapshot) {
            _familyMembers.add(snapshot.documents.first.data['name']);
          });
          notifyListeners();
          setBusy(false);
        });
      } else {
        setBusy(false);
      }
    });
  }
}
