import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtherViewModel extends BaseModel {
  FirebaseAuth _fireAuth;
  Firestore _firestore;
  String _familyID;
  String get familyID => _familyID;
  String _userID;

  OtherViewModel(
      {Firestore firestore, FirebaseAuth firebaseAuth, String userID}) {
    _fireAuth = firebaseAuth;
    _firestore = firestore;
    _userID = userID;
  }

  void getFamilyID() async {
    setBusy(true);
    var familySnapshot = await _firestore
        .collection('userfamily')
        .where('userID', isEqualTo: _userID)
        .getDocuments();
    if (familySnapshot.documents != null &&
        familySnapshot.documents.length > 0) {
      _familyID = familySnapshot.documents.first.data['familyID'];
      notifyListeners();
    }
    setBusy(false);
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
    setBusy(false);
  }

  Future logOut() {
    return _fireAuth.signOut();
  }
}
