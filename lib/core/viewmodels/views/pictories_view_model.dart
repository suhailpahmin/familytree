import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';

class PictoriesViewModel extends BaseModel {
  Firestore _firestore;
  String _userID;
  List<Pictory> _pictories = new List<Pictory>();
  List<Pictory> get pictories => _pictories;

  PictoriesViewModel({Firestore firestore, String userID}) {
    _firestore = firestore;
    _userID = userID;
  }

  void getPictories() async {
    setBusy(true);
    await _firestore.collection('pictories').document(_userID).get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        var pictoriesData = new List<dynamic>.from(snapshot.data['pictories']);
        _pictories = pictoriesFromJson(pictoriesData);
        notifyListeners();
      }
    });
    setBusy(false);
  }
  
  void updatePictories(Pictory data) {
    _pictories.add(data);
    notifyListeners();
  }
}