import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/viewmodels/base_model.dart';

class EditProfileViewModel extends BaseModel {
  String _birthPlace = '';
  String get birthPlace => _birthPlace;
  String _currentAddress = '';
  String get currentAddress => _currentAddress;
  String _currentState = '';
  String get currentState => _currentState;
  Firestore _firestore;

  EditProfileViewModel({Firestore firestore}) : _firestore = firestore;

  Future updateProfile(String userID) async {
    setBusy(true);
    await _firestore.collection('users').document(userID).updateData(
      {
        'birthPlace': _birthPlace,
        'currentAddress': _currentAddress,
        'currentState': _currentState,
      },
    );
    setBusy(false);
  }

  void setBirthPlace(String value) {
    _birthPlace = value;
    notifyListeners();
  }

  void setCurrentAddress(String value) {
    _currentAddress = value;
    notifyListeners();
  }

  void setCurrentState(String value) {
    _currentState = value;
    notifyListeners();
  }
}
