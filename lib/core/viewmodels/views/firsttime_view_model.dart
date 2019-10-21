import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';

class FirstTimeViewModel extends BaseModel {
  Firestore _firestore;
  List<FamilyData> _siblings = new List<FamilyData>();
  List<FamilyData> get siblings => _siblings;
  FamilyData _mother;
  FamilyData get mother => _mother;
  FamilyData _father;
  FamilyData get father => _father;

  String _name = '';
  String get name => _name;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  DateTime _birthDate = DateTime.now();
  DateTime get birthDate => _birthDate;
  int _genderIndex = 0;
  int get genderIndex => _genderIndex;
  String _gender = "Lelaki";
  String get gender => _gender;

  FirstTimeViewModel({Firestore firestore}) : _firestore = firestore;

  Future<bool> registerFamily(String userID) async {
    setBusy(true);
    var result = await _firestore.collection('family').add({
      'father': _father.toJson(),
      'mother': _mother.toJson(),
      'initiator': userID,
      'siblings': familiesToJson(siblings)
    });
    setBusy(false);
    if (result.documentID != null) {
      return true;
    } else {
      return false;
    }
  }

  void setSibling(FamilyData data) {
    _siblings.add(data);
    notifyListeners();
  }

  void setMother(FamilyData data) {
    data.gender = 'Wanita';
    _mother = data;
    notifyListeners();
  }

  void setFather(FamilyData data) {
    data.gender = 'Lelaki';
    _father = data;
    notifyListeners();
  }
}
