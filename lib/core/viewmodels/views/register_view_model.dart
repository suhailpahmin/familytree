import 'package:familytree/core/models/authentication/register_model.dart';
import 'package:familytree/core/providers/firebase_auth.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewModel extends BaseModel {
  FirebaseAuthProvider _auth;
  FirebaseUser _user;
  FirebaseUser get user => _user;
  String _email = "";
  String get email => _email;
  String _password = "";
  String get password => _password;
  String _name = "";
  String get name => _name;
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;
  DateTime _birthDate = DateTime.now();
  DateTime get birthDate => _birthDate;
  int _genderIndex = 0;
  int get genderIndex => _genderIndex;
  String _gender = "Lelaki";
  String get gender => _gender;

  RegisterViewModel({FirebaseAuthProvider firebaseAuthProvider})
      : _auth = firebaseAuthProvider;

  Future<String> registerUser() async {
    setBusy(true);
    _user = await _auth.register(new User(
      email: _email,
      password: _password,
      name: _name,
      gender: _gender,
      phoneNumber: _phoneNumber,
      birthDate: _birthDate
    )).catchError((error) {
      return error.toString();
    });
    notifyListeners();
    setBusy(false);
    if (_user != null && _user.uid.isNotEmpty) {
      return _user.uid.toString();
    } else {
      return "";
    }
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setBirthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
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
