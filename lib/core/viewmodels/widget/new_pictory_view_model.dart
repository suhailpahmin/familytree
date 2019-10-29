import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytree/core/models/pictory/pictory_model.dart';
import 'package:familytree/core/viewmodels/base_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shortid/shortid.dart';

class NewPictoryViewModel extends BaseModel {
  Firestore _firestore;
  FirebaseStorage _fireStorage;
  File _pictoryImage;
  File get pictoryImage => _pictoryImage;
  String _title;
  String get title => _title;
  String _story;
  String get story => _story;
  DateTime _date = DateTime.now();
  DateTime get date => _date;
  String _userID;
  Pictory _pictory;
  Pictory get pictory => _pictory;

  NewPictoryViewModel(
      {Firestore firestore, FirebaseStorage firebaseStorage, String userID}) {
    _firestore = firestore;
    _fireStorage = firebaseStorage;
    _userID = userID;
  }

  Future<String> postPictory() async {
    setBusy(true);
    try {
      final StorageReference storageReference = _fireStorage
          .ref()
          .child('pictories/$_userID/${basename(_pictoryImage.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_pictoryImage);
      final StorageTaskSnapshot downloadURL = (await uploadTask.onComplete);
      String imageURL = (await downloadURL.ref.getDownloadURL());
      shortid.characters('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
      if (imageURL != null && imageURL.isNotEmpty) {
        _pictory = new Pictory(
          image: imageURL,
          title: _title,
          story: _story,
          date: _date,
          id: shortid.generate(),
        );
        List<Pictory> newData = [_pictory];
        var getPictories =
            await _firestore.collection('pictories').document(_userID).get();
        if (getPictories.exists) {
          await _firestore.collection('pictories').document(_userID).updateData(
              {'pictories': FieldValue.arrayUnion(pictoriesToJson(newData))});
        } else {
          await _firestore.collection('pictories').document(_userID).setData(
              {'pictories': FieldValue.arrayUnion(pictoriesToJson(newData))});
        }
        setBusy(false);
        notifyListeners();
        return 'Pictory berjaya dihantar';
      } else {
        setBusy(false);
        return 'Gagal upload gambar';
      }
    } catch (err) {
      throw err;
    }
  }

  void updateImage(File pictoryImage) {
    _pictoryImage = pictoryImage;
    notifyListeners();
  }

  void updateTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void updateDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void updateStory(String story) {
    _story = story;
    notifyListeners();
  }
}
