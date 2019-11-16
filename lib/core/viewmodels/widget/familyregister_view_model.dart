import 'package:familytree/core/viewmodels/base_model.dart';

class FamilyRegisterViewModel extends BaseModel {
  String _name = "";
  String get name => _name;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  bool _validNumber = true;
  bool get validNumber => _validNumber;
  DateTime _birthDate = DateTime.now();
  DateTime get birthDate => _birthDate;
  int _genderIndex = 0;
  int get genderIndex => _genderIndex;
  String _gender = "Lelaki";
  String get gender => _gender;
  String _relation = "Adik Beradik";
  String get relation => _relation;

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setBirthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setValidNumber(bool value) {
    if (_phoneNumber.length > 0) {
      _validNumber = value;
      notifyListeners();
    }
  }

  void setRelation(String value) {
    _relation = value;
    notifyListeners();
  }

  void setGender(int value) {
    _genderIndex = value;
    if (_genderIndex == 0) {
      _gender = 'Lelaki';
    } else {
      _gender = 'Wanita';
    }
    notifyListeners();
  }
}
