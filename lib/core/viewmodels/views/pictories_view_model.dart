import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/core/models/pictory/pictorydata_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PictoriesViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseAuth _fireAuth;
  List<Pictory> _pictories = new List<Pictory>();
  List<Pictory> get pictories => _pictories;

  PictoriesViewModel({Firestore firestore, FirebaseAuth firebaseAuth}) {
    _firestore = firestore;
    _fireAuth = firebaseAuth;
  }

  Future newPictory(PictoryData data) async {
    setBusy(true);
    FirebaseUser user = await _fireAuth.currentUser();
    setBusy(false);
  }

  void initializeModel() async {
    FirebaseUser user = await _fireAuth.currentUser();
  }
}