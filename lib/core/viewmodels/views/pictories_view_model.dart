import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/pictory/pictorydata_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PictoriesViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  bool _hasFamily;
  bool get hasFamily => _hasFamily;
  String _familyID;
  String get familyID => _familyID;

  PictoriesViewModel({Firestore firestore, FirebaseAuth firebaseAuth}) {
    _firestore = firestore;
    _fireAuth = firebaseAuth;
  }

  Future newPictory(PictoryData data) async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    await _firestore.collection('pictories').add({
      'caption': data.caption,
      'createdOn': data.createdOn,
      'postedBy': user.uid,
      'familyID': _familyID,
    });
    setBusy(false);
  }

  void initializeModel() async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    await _firestore
        .collection('family')
        .where('members', arrayContains: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents != null && snapshot.documents.length > 0) {
        _hasFamily = true;
        _familyID = snapshot.documents[0].documentID;
      } else {
        _hasFamily = false;
      }
    });
    notifyListeners();
    setBusy(false);
  }
}
