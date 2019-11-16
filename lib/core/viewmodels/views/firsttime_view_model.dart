import 'package:familytree/core/models/authentication/firsttime_model.dart';
import 'package:familytree/core/models/family/familydata_model.dart';
import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/providers/sms_provider.dart';
import 'package:familytree/core/viewmodels/base_model.dart';

class FirstTimeViewModel extends BaseModel {
  List<FamilyData> _siblings = new List<FamilyData>();
  List<FamilyData> get siblings => _siblings;
  FamilyData _mother;
  FamilyData get mother => _mother;
  FamilyData _father;
  FamilyData get father => _father;
  FirebaseAuthProvider _firebaseAuthProvider;
  SmsProvider _smsProvider;

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

  FirstTimeViewModel(
      {FirebaseAuthProvider firebaseAuthProvider, SmsProvider smsProvider}) {
    _firebaseAuthProvider = firebaseAuthProvider;
    _smsProvider = smsProvider;
  }

  Future<String> registerFamily(FirstTime firstTime) async {
    try {
      setBusy(true);
      var registerResult = await _firebaseAuthProvider.registerFamily(
          firstTime.userID, father, mother, siblings);
      if (registerResult == 'Success') {
        String numbers = '${father.phoneNumber},${mother.phoneNumber}';
        siblings.forEach((s) => {
              if (s.id != firstTime.userID) {numbers += ',${s.phoneNumber}'}
            });
        var sendSmsResult = await _smsProvider.sendSms(numbers,
            'You are invited to Wareih by ${firstTime.userName}! Download it now on Playstore to join the family!');
        if (sendSmsResult) {
          return registerResult;
        } else {
          return 'SMS Failed';
        }
      }
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
