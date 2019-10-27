import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/base_model.dart';

class FirstTimeViewModel extends BaseModel {
  List<FamilyData> _siblings = new List<FamilyData>();
  List<FamilyData> get siblings => _siblings;
  FamilyData _mother;
  FamilyData get mother => _mother;
  FamilyData _father;
  FamilyData get father => _father;
  FirebaseAuthProvider _firebaseAuthProvider;

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

  FirstTimeViewModel({FirebaseAuthProvider firebaseAuthProvider}) {
    _firebaseAuthProvider = firebaseAuthProvider;
  }

  Future<String> registerFamily(String userID) async {
    try {
      setBusy(true);
      var registerResult = await _firebaseAuthProvider.registerFamily(
          userID, father, mother, siblings);
      setBusy(false);
      return registerResult;
    } catch (err) {
      setBusy(false);
      return err.message;
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
